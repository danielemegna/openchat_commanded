defmodule Openchat.Posts.Data.Post do
  @enforce_keys [:id, :user_id, :text, :datetime]
  defstruct @enforce_keys
end
