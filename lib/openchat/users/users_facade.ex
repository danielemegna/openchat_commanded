defmodule Openchat.Users.UsersFacade do

  alias Openchat.Users.{Commands,Queries,Data}
  alias Openchat.CommandedApp

  def get_all() do
    Queries.ListUsers.run()
  end

  def register_user(user_data) do
    command = Commands.RegisterUser.new(user_data)
    command_dispatch_result = CommandedApp.dispatch(command, returning: :aggregate_state)
    case command_dispatch_result do
      {:ok, state} ->
        user = %Data.User{
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
    command = struct(Commands.AuthenticateUser, credentials_data)
    command_dispatch_result = CommandedApp.dispatch(command, returning: :aggregate_state)
    case command_dispatch_result do
      {:ok, state} ->
        user = %Data.User{
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
