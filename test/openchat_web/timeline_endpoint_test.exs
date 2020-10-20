defmodule OpenchatWeb.Test.TimelineEndpointTest do
  use ExUnit.Case, async: false

  import Plug.Test

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
    user_id = Openchat.TestSupport.UsersEndpoint.register_user(%{
      username: "shady90",
      password: "v3ery$Ecure",
      about:    "About shady90 here."
    })

    conn = conn(:get, "/users/#{user_id}/timeline")
    |> OpenchatWeb.Router.call([])

    assert conn.status == 200
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
    user_id = Openchat.TestSupport.UsersEndpoint.register_user(%{
      username: "shady90",
      password: "v3ery$Ecure",
      about:    "About shady90 here."
    })

    conn = conn(:post, "/users/#{user_id}/timeline", %{ text: "First user post." })
    |> OpenchatWeb.Router.call([])

    assert conn.status == 201
    assert Enum.member?(conn.resp_headers, {"content-type", "application/json"})
    response_body = Jason.decode!(conn.resp_body)
    assert Enum.count(Map.keys(response_body)) == 4
    assert_valid_uuid response_body["postId"]
    assert user_id == response_body["userId"]
    assert "First user post." == response_body["text"]
    assert_datetime_format response_body["dateTime"]

    #%{ "postId" => firstPostId, "dateTime" => firstPostDateTime } = response_body
    #%{ "postId" => secondPostId, "dateTime" => secondPostDateTime } = submit_post(user_id, "Second user post.")

    #conn = conn(:get, "/users/#{user_id}/timeline")
    #|> OpenchatWeb.Router.call([])

    #assert conn.status == 201
    #assert Enum.member?(conn.resp_headers, {"content-type", "application/json"})
    #assert Jason.decode!(conn.resp_body) == [
    #  %{
    #    "postId" => secondPostId,
    #    "userId" => user_id,
    #    "text" => "Second user post.",
    #    "dateTime" => secondPostDateTime
    #  },
    #  %{
    #    "postId" => firstPostId,
    #    "userId" => user_id,
    #    "text" => "First user post.",
    #    "dateTime" => firstPostDateTime
    #  }
    #]
  end

  #defp submit_post(user_id, text) do
  #  conn = conn(:post, "/users/#{user_id}/timeline", %{ text: text })
  #  |> OpenchatWeb.Router.call([])

  #  assert conn.status == 201
  #  Jason.decode!(conn.resp_body)
  #end

  defp assert_valid_uuid(value) do
    assert Regex.match?(~r/^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i, value)
  end

  def assert_datetime_format(value) do
    assert Regex.match?(~r/^((19|20)[0-9][0-9])[-](0[1-9]|1[012])[-](0[1-9]|[12][0-9]|3[01])[T]([01][0-9]|[2][0-3])[:]([0-5][0-9])[:]([0-5][0-9])Z$/i, value)
  end
end
