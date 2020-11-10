defmodule Openchat.Repositories.AgentFollowingRepository do
  alias Openchat.Repositories.FollowingRepository
  @behaviour FollowingRepository

  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> [] end, name: :following_repository)
  end

  @impl FollowingRepository
  def get_by_follower_id(user_id) do
    Agent.get(:following_repository, &(&1))
    |> Enum.filter(fn f -> f.follower_id == user_id end)
  end

  @impl FollowingRepository
  def store(following) do
    Agent.update(:following_repository, &([following | &1]))
    :ok
  end

end
