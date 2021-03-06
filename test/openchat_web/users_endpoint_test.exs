defmodule OpenchatWeb.Test.UsersEndpointTest do
  use ExUnit.Case, async: false

  import Plug.Test
  import Assertions, only: [assert_lists_equal: 2]
  import Openchat.TestSupport.Assertions

  alias Openchat.TestSupport

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

    assert conn.status == 200, inspect(conn)
    assert Enum.member?(conn.resp_headers, {"content-type", "application/json"})
    assert Jason.decode!(conn.resp_body) == []
  end

  test "register a new user" do
    conn = TestSupport.UsersEndpoint.post(%{
      username: "shady90",
      password: "v3ery$Ecure",
      about:    "About shady90 here."
    })

    assert conn.status == 201, inspect(conn)
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
    TestSupport.UsersEndpoint.register_user("shady90")

    conn = TestSupport.UsersEndpoint.post(%{
      username: "shady90",
      password: "any",
      about:    "any"
    })

    assert conn.status == 400
    assert Enum.member?(conn.resp_headers, {"content-type", "text/plain"})
    assert conn.resp_body == "Username already in use."
  end

  test "register some users and get users list" do
    shadyid = TestSupport.UsersEndpoint.register_user(%{
      username: "shady90",
      password: "v3ery$Ecure",
      about:    "About shady90 here."
    })
    mariaid = TestSupport.UsersEndpoint.register_user(%{
      username: "maria89",
      password: "$ecur3",
      about:    "About maria89 here."
    })

    conn = conn(:get, "/users")
    |> OpenchatWeb.Router.call([])

    assert conn.status == 200, inspect(conn)
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
end
