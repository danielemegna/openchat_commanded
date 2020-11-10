defmodule OpenchatWeb.Router do
  use Plug.Router

  alias Openchat.Users.Data.User
  alias Openchat.Posts.Data.Post

  plug Plug.Parsers,
    parsers: [:json],
    json_decoder: {Jason, :decode!, [[keys: :atoms]]}

  plug :match
  plug :dispatch

  get "/users" do
    users = Openchat.Users.UsersFacade.get_all()
    response_body = users |> Enum.map(&user_from/1)
    send_json_resp(conn, 200, response_body)
  end

  post "/users" do
    result = Openchat.Users.UsersFacade.register_user(conn.params)
    case result do
      {:ok, user} ->
        response_body = user_from(user)
        send_json_resp(conn, 201, response_body)
      {:error, :username_already_used} ->
        send_text_resp(conn, 400, "Username already in use.")
    end
  end

  post "/login" do
    result = Openchat.Users.UsersFacade.authenticate_user(conn.params)
    case result do
      {:ok, user} ->
        response_body = user_from(user)
        send_json_resp(conn, 200, response_body)
      {:error, :invalid_credentials} ->
        send_text_resp(conn, 404, "Invalid credentials.")
    end
  end

  get "/users/:user_id/timeline" do
    user_id = normalize(conn.params).user_id
    result = Openchat.Posts.PostsFacade.get_timeline(user_id)
    case result do
      {:ok, posts} ->
        response_body = post_from(posts)
        send_json_resp(conn, 200, response_body)
      {:error, :user_not_found} ->
        send_text_resp(conn, 404, "User not found.")
    end
  end

  post "/users/:user_id/timeline" do
    result = Openchat.Posts.PostsFacade.submit_post(normalize(conn.params))
    case result do
      {:ok, post} ->
        response_body = post_from(post)
        send_json_resp(conn, 201, response_body)
      {:error, :user_not_found} ->
        send_text_resp(conn, 404, "User not found.")
    end
  end

  get "/followings/:user_id/followees" do
    params = normalize(conn.params)
    case params.user_id do
      "unexisting_id" -> send_text_resp(conn, 404, "User not found.")
      _ -> send_json_resp(conn, 200, [])
    end
  end

  match _ do
    send_text_resp(conn, 404, "Oops!")
  end

  defp user_from(%User{} = struct) do
    struct |> Map.take([:id, :username, :about])
  end

  defp post_from(list) when is_list(list),
    do: Enum.map(list, &post_from/1)

  defp post_from(%Post{} = struct) do
    %{
      postId: struct.id,
      userId: struct.user_id,
      text: struct.text,
      dateTime: struct.datetime
      |> DateTime.truncate(:second)
      |> DateTime.to_iso8601()
    }
  end

  defp send_json_resp(conn, status_code, body) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(status_code, Jason.encode!(body))
  end

  defp send_text_resp(conn, status_code, text) do
    conn
    |> put_resp_header("content-type", "text/plain")
    |> send_resp(status_code, text)
  end

  defp normalize(params) do
    Map.new(params, fn {k, v} -> {String.to_atom(k), v} end)
  end

end
