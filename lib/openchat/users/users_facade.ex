defmodule Openchat.Users.UsersFacade do

  alias Openchat.Repositories.AgentUserRepository, as: UserRepository
  alias Openchat.Users.Commands.AuthenticateUser
  alias Openchat.Users.Commands.RegisterUser
  alias Openchat.Users.Data.User

  def get_all() do
    UserRepository.get_all()
  end

  def register_user(user_data) do
    command = struct(RegisterUser, user_data)
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
