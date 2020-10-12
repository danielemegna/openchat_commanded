defmodule Openchat.Repositories.AgentUserRepository do
  alias Openchat.Repositories.UserRepository
  @behaviour UserRepository

  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> [] end, name: :user_repository)
  end

  @impl UserRepository
  def get_all do
    Agent.get(:user_repository, &(&1))
  end

  @impl UserRepository
  def get_by_username(username) do
    Agent.get(:user_repository, &(&1))
      |> Enum.find(fn u -> u.username == username end)
  end

  @impl UserRepository
  def get_by_id(user_id) do
    Agent.get(:user_repository, &(&1))
      |> Enum.find(fn u -> u.id == user_id end)
  end

  @impl UserRepository
  def store(user) do
    Agent.update(:user_repository, &([user | &1]))
    :ok
  end

end
