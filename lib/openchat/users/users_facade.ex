defmodule Openchat.Users.UsersFacade do

  alias Openchat.Users.Commands.AuthenticateUser
  alias Openchat.Users.Commands.RegisterUser
  alias Openchat.Users.Data.User
  alias Openchat.Users.Queries.ListUsers

  def get_all() do
    ListUsers.run()
  end

  def register_user(user_data) do
    command = RegisterUser.new(user_data)
    command_dispatch_result = Openchat.CommandedApp.dispatch(command, returning: :aggregate_state)
    case command_dispatch_result do
      {:ok, state} ->
        user = %User{
          id:       state.id,
          username: command.username,
          password: command.password,
          about:    command.about
        }
        {:ok, user}
      {:error, _reason} = error -> error
    end
  end

  def authenticate_user(credentials_data) do
    command = struct(AuthenticateUser, credentials_data)
    command_dispatch_result = Openchat.CommandedApp.dispatch(command, returning: :aggregate_state)
    case command_dispatch_result do
      {:ok, state} ->
        user = %User{
          id:       state.id,
          username: state.username,
          password: state.password,
          about:    state.about
        }
        {:ok, user}
      {:error, _reason} = error -> error
    end
  end

end
