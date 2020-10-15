defmodule Openchat.TestSupport.UsersEndpoint do
  import Plug.Test, only: [conn: 3]
  import ExUnit.Assertions, only: [assert: 1]

  def register_user(user_request_body) do
    conn = post(user_request_body)
    assert conn.status == 201

    conn.resp_body
    |> Jason.decode!()
    |> Map.fetch!("id")
  end

  def post(request_body) do
    conn(:post, "/users", Jason.encode!(request_body))
    |> Plug.Conn.put_req_header("content-type", "application/json")
    |> OpenchatWeb.Router.call([])
  end

end
