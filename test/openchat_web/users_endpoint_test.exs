defmodule OpenchatWeb.Test.UsersEndpointTest do
  use ExUnit.Case, async: false

  import Plug.Test

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
    request_body = Jason.encode!(%{
      username: "shady90",
      password: "v3ery$Ecure",
      about:    "About shady90 here."
    })

    conn = conn(:post, "/users", request_body)
    |> Plug.Conn.put_req_header("content-type", "application/json")
    |> OpenchatWeb.Router.call([])

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

  defp assert_valid_uuid(value) do
    assert Regex.match?(~r/^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i, value)
  end
end
