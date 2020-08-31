defmodule OpenchatWeb.Router do
  use Plug.Router

  plug Plug.Parsers,
    parsers: [:json],
    json_decoder: {Jason, :decode!, [[keys: :atoms]]}

  plug :match
  plug :dispatch

  get "/users" do
    send_resp(conn, 200, [] |> Jason.encode!())
  end

  post "/users" do
    command = Openchat.Users.Commands.RegisterUser.new(conn.params)
    :ok = Openchat.CommandedApp.dispatch(command, consistency: :eventual)
    ok_response = %{
      id:       command.id,
      username: command.username,
      about:    command.about
    }
    send_resp(conn, 201, ok_response |> Jason.encode!())
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end

end
