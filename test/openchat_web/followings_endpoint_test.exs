defmodule OpenchatWeb.Test.FollowingsEndpointTest do
  use ExUnit.Case, async: false

  import Plug.Test

  setup do
    Application.ensure_all_started(:openchat)
    on_exit(fn ->
      Application.stop(:openchat)
    end)
    :ok
  end

  test "get followees attempt with invalid user id" do
    conn = conn(:get, "/followings/unexisting_id/followees")
    |> OpenchatWeb.Router.call([])

    assert conn.status == 404
    assert Enum.member?(conn.resp_headers, {"content-type", "text/plain"})
    assert conn.resp_body == "User not found."
  end

end
