defmodule Openchat.Users.Aggregates.User do
  defstruct [:id, :username]
  
  alias Openchat.Users.Commands.RegisterUser
  alias Openchat.Users.Events.UserRegistered

  def execute(%__MODULE__{username: username}, %RegisterUser{}) when username != nil, do:
    {:error, :username_already_used}

  def execute(%__MODULE__{}, %RegisterUser{} = command) do
    %UserRegistered{id: UUID.uuid4(), username: command.username, password: command.password, about: command.about}
  end

  # state mutators

  def apply(%__MODULE__{} = state, %UserRegistered{id: id, username: username}) do
    %{state | id: id, username: username}
  end

end
