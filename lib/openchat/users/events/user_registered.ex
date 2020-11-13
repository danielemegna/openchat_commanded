defmodule Openchat.Users.Events.UserRegistered do
  #@derive Jason.Encoder
  @enforce_keys [:user_id, :username, :password, :about]
  defstruct @enforce_keys
end
