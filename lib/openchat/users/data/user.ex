defmodule Openchat.Users.Data.User do
  @type t :: %__MODULE__{
    id: String.t,
    username: String.t,
    password: String.t,
    about: String.t
  }
  @enforce_keys [:id, :username, :password, :about]
  defstruct @enforce_keys
end
