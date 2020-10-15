defmodule OpenchatWeb.Test.LoginEndpointTest do
  use ExUnit.Case, async: false

  import Plug.Test

  setup do
    Application.ensure_all_started(:openchat)
    on_exit(fn ->
      Application.stop(:openchat)
    end)
    :ok
  end

  test "login attempt with unexising user" do
    conn = post(%{username: "not.existing", password: "any"})

    assert conn.status == 404
    assert Enum.member?(conn.resp_headers, {"content-type", "text/plain"})
    assert conn.resp_body == "Invalid credentials."
  end

  test "register and login a user" do
    shadyid = Openchat.TestSupport.UsersEndpoint.register_user(%{
      username: "shady90",
      password: "v3ery$Ecure",
      about:    "About shady90 here."
    })

    conn = post(%{username: "shady90", password: "v3ery$Ecure"})

    assert conn.status == 200
    assert Enum.member?(conn.resp_headers, {"content-type", "application/json"})
    assert Jason.decode!(conn.resp_body) == %{
      "id"       => shadyid,
      "username" => "shady90",
      "about"    => "About shady90 here."
    }

    conn = post(%{username: "shady90", password: "wrong"})

    assert conn.status == 404
    assert Enum.member?(conn.resp_headers, {"content-type", "text/plain"})
    assert conn.resp_body == "Invalid credentials."
  end

  defp post(request_body) do
    conn(:post, "/login", Jason.encode!(request_body))
    |> Plug.Conn.put_req_header("content-type", "application/json")
    |> OpenchatWeb.Router.call([])
  end
end
