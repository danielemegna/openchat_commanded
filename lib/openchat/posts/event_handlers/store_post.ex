defmodule Openchat.Posts.EventHandlers.StorePost do
  use Commanded.Event.Handler,
    application: Openchat.CommandedApp,
    name: __MODULE__,
    consistency: :eventual

  alias Openchat.Repositories.AgentPostRepository, as: PostRepository
  alias Openchat.Posts.Events
  alias Openchat.Posts.Data

  def handle(%Events.PostSubmitted{} = event, _metadata) do
    user = struct(Data.Post, Map.from_struct(event))
    PostRepository.store(user)
    :ok
  end
end
