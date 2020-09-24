defmodule Openchat.Users.UsersFacade do

  alias Openchat.Users.Commands.RegisterUser

  def get_all() do
    Openchat.Users.EventHandlers.UserStore.get_all()
  end

  def register_user(user_data) do
    command = struct(RegisterUser, user_data)
    command_dispatch_result = Openchat.CommandedApp.dispatch(
      command, consistency: :strong, returning: :aggregate_state
    )
    case command_dispatch_result do
      {:ok, state} ->
        user = %{
          id:       state.id,
          username: command.username,
          about:    command.about
        }
        {:ok, user}
      {:error, _reason} = error -> error
    end
  end

end
