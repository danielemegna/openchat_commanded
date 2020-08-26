defmodule OpenchatWeb.Test.UsersEndpointTest do
  use ExUnit.Case, async: false

  import Plug.Test

  test "Oops! response on unexisting route" do
    conn = conn(:get, "/unexisting")
        |> OpenchatWeb.Router.call([])

    assert conn.status == 404
    assert conn.resp_body == "Oops!"
  end

  test "get users from /users endpoint on new empty application" do
    conn = conn(:get, "/users")
        |> OpenchatWeb.Router.call([])

    assert conn.status == 200
    assert Jason.decode!(conn.resp_body) == []
  end
end
