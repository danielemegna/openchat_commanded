defmodule Openchat.Users.Aggregates.User do
  defstruct [:id, :username, :password, :about]
  
  alias __MODULE__, as: State
  alias Openchat.Users.Commands.AuthenticateUser
  alias Openchat.Users.Commands.RegisterUser
  alias Openchat.Users.Events.UserRegistered

  def execute(%State{username: username}, %RegisterUser{}) when username != nil, do:
    {:error, :username_already_used}
  def execute(%State{}, %RegisterUser{} = command) do
    %UserRegistered{
      id: UUID.uuid4(),
      username: command.username,
      password: command.password,
      about: command.about
    }
  end

  def execute(
    %State{username: username, password: password},
    %AuthenticateUser{username: username, password: password}
  ), do: :ok
  def execute(%State{}, %AuthenticateUser{}), do: {:error, :invalid_credentials}

  # state mutators

  def apply(%State{} = state, %UserRegistered{} = event) do
    %{ state |
      id: event.id,
      username: event.username,
      password: event.password,
      about: event.about
    }
  end

end
