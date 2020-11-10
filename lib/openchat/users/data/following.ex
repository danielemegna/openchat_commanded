defmodule Openchat.Users.Data.Following do
  @type t :: %__MODULE__{
    follower_id: String.t,
    followee_id: String.t
  }
  @enforce_keys [:follower_id, :followee_id]
  defstruct @enforce_keys
end
