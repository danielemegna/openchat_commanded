defmodule OpenchatWeb.Test.FollowingsEndpointTest do
  use ExUnit.Case, async: false

  import Plug.Test
  alias Openchat.TestSupport

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

    assert conn.status == 404, inspect(conn)
    assert Enum.member?(conn.resp_headers, {"content-type", "text/plain"})
    assert conn.resp_body == "User not found."
  end

  test "get followees without any followings" do
    user_id = TestSupport.UsersEndpoint.register_user()

    conn = conn(:get, "/followings/#{user_id}/followees")
    |> OpenchatWeb.Router.call([])

    assert conn.status == 200, inspect(conn)
    assert Enum.member?(conn.resp_headers, {"content-type", "application/json"})
    assert Jason.decode!(conn.resp_body) == []
  end

  test "follow existing user" do
    first_user_id = TestSupport.UsersEndpoint.register_user("first.username")
    second_user_id = TestSupport.UsersEndpoint.register_user("second.username")

    conn = conn(:post, "/followings", %{
      followerId: first_user_id,
      followeeId: second_user_id
    })
    |> OpenchatWeb.Router.call([])

    assert conn.status == 201, inspect(conn)
    assert Enum.member?(conn.resp_headers, {"content-type", "text/plain"})
    assert conn.resp_body == "Following created."
  end

end
