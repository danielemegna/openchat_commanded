defmodule Openchat.Users.Aggregates.User do
  defstruct []
  
  alias __MODULE__, as: State
  alias Openchat.Users.Commands.RegisterUser
  alias Openchat.Users.Events.UserRegistered

  def execute(%State{}, %RegisterUser{} = command) do
    struct(UserRegistered, Map.from_struct(command))
  end

  # state mutators

  def apply(%State{} = state, %UserRegistered{}), do: state

end
