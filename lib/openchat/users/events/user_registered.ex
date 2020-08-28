defmodule Openchat.Users.Events.UserRegistered do
  @derive Jason.Encoder

  @enforce_keys [:id, :username, :password, :about]
  defstruct @enforce_keys
end
