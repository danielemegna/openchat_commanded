defmodule Openchat.Posts.Events.PostSubmitted do
  @enforce_keys [:post_id, :user_id, :text, :datetime]
  defstruct @enforce_keys
end
