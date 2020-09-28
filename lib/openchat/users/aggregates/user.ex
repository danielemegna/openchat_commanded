defmodule Openchat.Users.Aggregates.User do
  defstruct [:id, :username, :password, :about]
  
  alias Openchat.Users.Commands.AuthenticateUser
  alias Openchat.Users.Commands.RegisterUser
  alias Openchat.Users.Events.UserRegistered

  def execute(%__MODULE__{username: username}, %RegisterUser{}) when username != nil, do:
    {:error, :username_already_used}
  def execute(%__MODULE__{}, %RegisterUser{} = command) do
    %UserRegistered{id: UUID.uuid4(), username: command.username, password: command.password, about: command.about}
  end

  def execute(%__MODULE__{password: password}, %AuthenticateUser{password: password}), do: :ok
  def execute(%__MODULE__{}, %AuthenticateUser{}), do: {:error, :invalid_credentials}

  # state mutators

  def apply(%__MODULE__{} = state, %UserRegistered{} = event) do
    %{state | id: event.id, username: event.username, password: event.password, about: event.about}
  end

end
