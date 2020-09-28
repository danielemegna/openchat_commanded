defmodule Openchat.Users.Commands.AuthenticateUser do
  @enforce_keys [:username, :password]
  defstruct @enforce_keys
end
