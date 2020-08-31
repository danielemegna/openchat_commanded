defmodule OpenchatWeb.Router do
  use Plug.Router

  plug Plug.Parsers,
    parsers: [:json],
    json_decoder: {Jason, :decode!, [[keys: :atoms]]}

  plug :match
  plug :dispatch

  get "/users" do
    send_json_resp(conn, 200, [])
  end

  post "/users" do
    command = Openchat.Users.Commands.RegisterUser.new(conn.params)
    :ok = Openchat.CommandedApp.dispatch(command, consistency: :eventual)
    ok_response = %{
      id:       command.id,
      username: command.username,
      about:    command.about
    }

    send_json_resp(conn, 201, ok_response)
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
