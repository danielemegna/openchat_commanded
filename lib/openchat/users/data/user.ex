defmodule Openchat.Users.Data.User do
  @enforce_keys [:id, :username, :password, :about]
  defstruct @enforce_keys
end
