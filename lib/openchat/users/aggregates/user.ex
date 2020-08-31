defmodule Openchat.Users.Aggregates.User do
  defstruct [:id, :username, :password, :about]
  
  alias Openchat.Users.Commands.RegisterUser
  alias Openchat.Users.Events.UserRegistered

  def execute(%__MODULE__{} = _state, %RegisterUser{} = _command) do
    %UserRegistered{id: "fixme", username: "fixme", password: "fixme", about: "fixme"}
  end

  # state mutators

  def apply(%__MODULE__{} = state, %UserRegistered{} = _event) do
    state
  end

end
