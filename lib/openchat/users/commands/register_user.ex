defmodule Openchat.Users.Commands.RegisterUser do
  @enforce_keys [:username, :password, :about]
  defstruct @enforce_keys
end
