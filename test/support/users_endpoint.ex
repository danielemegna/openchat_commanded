defmodule Openchat.TestSupport.UsersEndpoint do
  import Plug.Test, only: [conn: 3]
  import ExUnit.Assertions, only: [assert: 1]

  def register_user(user_request_body) when is_map(user_request_body) do
    conn = post(user_request_body)
    assert conn.status == 201

    # this is enought for UserRegistered event handler
    # to register the user asynchronously
    # TODO: find a better way to wait event handlers in test
    :timer.sleep(10)

    conn.resp_body
    |> Jason.decode!()
    |> Map.fetch!("id")
  end

  def register_user(
    username \\ "shady90",
    password \\ "$3cureP4ass",
    about \\ "About user."
  ) do
    register_user(%{
      username: username,
      password: password,
      about:    about
    })
  end

  def post(request_body) do
    conn(:post, "/users", Jason.encode!(request_body))
    |> Plug.Conn.put_req_header("content-type", "application/json")
    |> OpenchatWeb.Router.call([])
  end

end
