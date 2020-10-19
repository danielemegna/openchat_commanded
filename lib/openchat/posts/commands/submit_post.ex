defmodule Openchat.Posts.Commands.SubmitPost do
  @enforce_keys [:id, :user_id, :text]
  defstruct @enforce_keys
end
