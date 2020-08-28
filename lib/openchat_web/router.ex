defmodule OpenchatWeb.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/users" do
    send_resp(conn, 200, [] |> Jason.encode!())
  end

  post "/users" do
    request_body = read_body(conn) |> elem(1) |> Jason.decode!(keys: :atoms)
    command = struct(Openchat.Users.Commands.RegisterUser, request_body)
    Openchat.CommandedApp.dispatch(command)

    response = %{
      id:       UUID.uuid4(),
      username: "shady90",
      about:    "About shady90 here."
    }
    send_resp(conn, 201, response |> Jason.encode!())
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
