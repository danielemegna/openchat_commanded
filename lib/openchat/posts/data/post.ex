defmodule Openchat.Posts.Data.Post do
  @type t :: %__MODULE__{
    id: String.t,
    user_id: String.t,
    text: String.t,
    datetime: DateTime.t
  }
  @enforce_keys [:id, :user_id, :text, :datetime]
  defstruct @enforce_keys
end
