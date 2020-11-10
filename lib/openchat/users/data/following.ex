defmodule Openchat.Users.Data.Following do
  @enforce_keys [:follower_id, :followee_id]
  defstruct @enforce_keys
end
