defmodule Openchat.Posts.Commands.SubmitPost do
  @enforce_keys [:post_id, :user_id, :text]
  defstruct @enforce_keys

  def new(params) do
    params = params |> Map.put(:post_id, UUID.uuid4())
    struct(__MODULE__, params)
  end
end
