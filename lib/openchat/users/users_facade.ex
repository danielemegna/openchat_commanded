defmodule Openchat.Users.UsersFacade do

  alias Openchat.Users.{Commands,Queries,Data}
  alias Openchat.CommandedApp

  def get_all() do
    Queries.ListUsers.run()
  end

  def register_user(user_data) do
    if username_already_used?(user_data.username) do
      {:error, :username_already_used}
    else
      command = Commands.RegisterUser.new(user_data)
      CommandedApp.dispatch(command)
      |> case do
        :ok -> {:ok, user_from(command)}
        error -> error
      end
    end
  end

  def authenticate_user(%{username: username, password: password}) do
    Queries.UserByUsername.run(username)
    |> case do
      %Data.User{password: ^password} = user -> {:ok, user}
      _ -> {:error, :invalid_credentials}
    end
  end

  defp user_from(%Commands.RegisterUser{} = c) do
    %Data.User{
      id:       c.user_id,
      username: c.username,
      password: c.password,
      about:    c.about
    }
  end

  defp username_already_used?(username) do
    Queries.UserByUsername.run(username)
    |> case do
      %Data.User{} -> true
      nil -> false
    end
  end

end
