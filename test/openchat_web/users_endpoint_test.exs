defmodule OpenchatWeb.Test.UsersEndpointTest do
  use ExUnit.Case, async: false

  import Plug.Test
  import Assertions, only: [assert_lists_equal: 2]

  setup do
    Application.ensure_all_started(:openchat)
    on_exit(fn ->
      Application.stop(:openchat)
    end)
    :ok
  end


  test "Oops! response on unexisting route" do
    conn = conn(:get, "/unexisting")
    |> OpenchatWeb.Router.call([])

    assert conn.status == 404
    assert Enum.member?(conn.resp_headers, {"content-type", "text/plain"})
    assert conn.resp_body == "Oops!"
  end

  test "get users from /users endpoint on new empty application" do
    conn = conn(:get, "/users")
    |> OpenchatWeb.Router.call([])

    assert conn.status == 200
    assert Enum.member?(conn.resp_headers, {"content-type", "application/json"})
    assert Jason.decode!(conn.resp_body) == []
  end

  test "register a new user" do
    conn = post(%{
      username: "shady90",
      password: "v3ery$Ecure",
      about:    "About shady90 here."
    })

    assert conn.status == 201
    assert Enum.member?(conn.resp_headers, {"content-type", "application/json"})
    response_body = Jason.decode!(conn.resp_body)
    assert Enum.count(Map.keys(response_body)) == 3
    assert %{
      "id"       => shadyid,
      "username" => "shady90",
      "about"    => "About shady90 here."
    } = response_body
    assert_valid_uuid shadyid
  end

  test "cannot use already used username" do
    register_user(%{
      username: "shady90",
      password: "v3ery$Ecure",
      about:    "About shady90 here."
    })

    conn = post(%{
      username: "shady90",
      password: "any",
      about:    "any"
    })

    assert conn.status == 400
    assert Enum.member?(conn.resp_headers, {"content-type", "text/plain"})
    assert conn.resp_body == "Username already in use."
  end

  test "register some users and get users list" do
    shadyid = register_user(%{
      username: "shady90",
      password: "v3ery$Ecure",
      about:    "About shady90 here."
    })
    mariaid = register_user(%{
      username: "maria89",
      password: "$ecur3",
      about:    "About maria89 here."
    })

    conn = conn(:get, "/users")
    |> OpenchatWeb.Router.call([])

    assert conn.status == 200
    assert Enum.member?(conn.resp_headers, {"content-type", "application/json"})
    assert_lists_equal Jason.decode!(conn.resp_body), [
      %{
        "id"       => shadyid,
        "username" => "shady90",
        "about"    => "About shady90 here."
      },
      %{
        "id"       => mariaid,
        "username" => "maria89",
        "about"    => "About maria89 here."
      }
    ]
  end

  defp register_user(user_request_body) do
    conn = post(user_request_body)
    assert conn.status == 201

    conn.resp_body
    |> Jason.decode!()
    |> Map.fetch!("id")
  end

  defp post(request_body) do
    conn(:post, "/users", Jason.encode!(request_body))
    |> Plug.Conn.put_req_header("content-type", "application/json")
    |> OpenchatWeb.Router.call([])
  end

  defp assert_valid_uuid(value) do
    assert Regex.match?(~r/^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i, value)
  end
end
