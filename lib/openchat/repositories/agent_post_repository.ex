defmodule Openchat.Repositories.AgentPostRepository do
  alias Openchat.Repositories.PostRepository
  @behaviour PostRepository

  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> [] end, name: :post_repository)
  end

  @impl PostRepository
  def get_by_userid(user_id) do
    Agent.get(:post_repository, &(&1))
      |> Enum.filter(fn p -> p.user_id == user_id end)
  end

  @impl PostRepository
  def store(post) do
    Agent.update(:post_repository, &([post | &1]))
    :ok
  end

end
