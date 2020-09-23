defmodule OpenchatWeb.Router do
  use Plug.Router

  alias Openchat.Users.Commands.RegisterUser

  plug Plug.Parsers,
    parsers: [:json],
    json_decoder: {Jason, :decode!, [[keys: :atoms]]}

  plug :match
  plug :dispatch

  get "/users" do
    users = Openchat.Users.EventHandlers.UserStore.get_all()
    |> Enum.map(& Map.take(&1, [:id, :username, :about]))

    send_json_resp(conn, 200, users)
  end

  post "/users" do
    command = struct(RegisterUser, conn.params)
    case Openchat.CommandedApp.dispatch(command, consistency: :strong, returning: :aggregate_state) do
      {:ok, state} ->
        ok_response = %{
          id:       state.id,
          username: command.username,
          about:    command.about
        }

        send_json_resp(conn, 201, ok_response)
      {:error, :username_already_used} ->
        send_text_resp(conn, 400, "Username already in use.")
    end
  end

  match _ do
    send_text_resp(conn, 404, "Oops!")
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

end
