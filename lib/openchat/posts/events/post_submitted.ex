defmodule Openchat.Posts.Events.PostSubmitted do
  @enforce_keys [:id, :user_id, :text, :datetime]
  defstruct @enforce_keys
end
