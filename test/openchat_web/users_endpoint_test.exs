defmodule OpenchatWeb.Test.UsersEndpointTest do
  use ExUnit.Case, async: false

  import Plug.Test

  test "Oops! response on unexisting route" do
    conn = conn(:get, "/unexisting")
        |> OpenchatWeb.Router.call([])

    assert conn.status == 404
    assert conn.resp_body == "Oops!"
  end

end
