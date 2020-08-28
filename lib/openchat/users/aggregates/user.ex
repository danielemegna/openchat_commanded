defmodule Openchat.Users.Aggregates.User do
  defstruct [:id, :username, :password, :about]
  
  alias Openchat.Users.Commands.RegisterUser

  def execute(%__MODULE__{} = _state, %RegisterUser{} = _command) do
    []
  end
end
