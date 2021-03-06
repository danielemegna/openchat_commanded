defmodule OpenchatWeb.Test.TimelineEndpointTest do
  use ExUnit.Case, async: false

  import Plug.Test
  import Openchat.TestSupport.Assertions

  setup do
    Application.ensure_all_started(:openchat)
    on_exit(fn ->
      Application.stop(:openchat)
    end)
    :ok
  end

  test "timeline on unexisting user" do
    conn = conn(:get, "/users/unexisting_id/timeline")
    |> OpenchatWeb.Router.call([])

    assert conn.status == 404
    assert Enum.member?(conn.resp_headers, {"content-type", "text/plain"})
    assert conn.resp_body == "User not found."
  end

  test "empty user timeline" do
    user_id = Openchat.TestSupport.UsersEndpoint.register_user()

    conn = conn(:get, "/users/#{user_id}/timeline")
    |> OpenchatWeb.Router.call([])

    assert conn.status == 200, inspect(conn)
    assert Enum.member?(conn.resp_headers, {"content-type", "application/json"})
    assert Jason.decode!(conn.resp_body) == []
  end

  test "post submit attempt with unexisting user" do
    conn = conn(:post, "/users/unexisting_id/timeline", %{
      text: "Post text."
    })
    |> OpenchatWeb.Router.call([])

    assert conn.status == 404
    assert Enum.member?(conn.resp_headers, {"content-type", "text/plain"})
    assert conn.resp_body == "User not found."
  end

  test "submit post and fetch user timeline" do
    user_id = Openchat.TestSupport.UsersEndpoint.register_user()

    conn = conn(:post, "/users/#{user_id}/timeline", %{ text: "First user post." })
    |> OpenchatWeb.Router.call([])

    assert conn.status == 201, inspect(conn)
    assert Enum.member?(conn.resp_headers, {"content-type", "application/json"})
    response_body = Jason.decode!(conn.resp_body)
    assert Enum.count(Map.keys(response_body)) == 4
    assert_valid_uuid response_body["postId"]
    assert user_id == response_body["userId"]
    assert "First user post." == response_body["text"]
    assert_datetime_format response_body["dateTime"]

    %{ "postId" => firstPostId, "dateTime" => firstPostDateTime } = response_body
    %{ "postId" => secondPostId, "dateTime" => secondPostDateTime } = submit_post(user_id, "Second user post.")

    conn = conn(:get, "/users/#{user_id}/timeline")
    |> OpenchatWeb.Router.call([])

    assert conn.status == 200, inspect(conn)
    assert Enum.member?(conn.resp_headers, {"content-type", "application/json"})
    assert Jason.decode!(conn.resp_body) == [
     %{
        "postId" => secondPostId,
        "userId" => user_id,
        "text" => "Second user post.",
        "dateTime" => secondPostDateTime
      },
      %{
        "postId" => firstPostId,
        "userId" => user_id,
        "text" => "First user post.",
        "dateTime" => firstPostDateTime
      }
    ]
  end

  defp submit_post(user_id, text) do
    conn = conn(:post, "/users/#{user_id}/timeline", %{ text: text })
    |> OpenchatWeb.Router.call([])

    assert conn.status == 201, inspect(conn)
    Jason.decode!(conn.resp_body)
  end

end
