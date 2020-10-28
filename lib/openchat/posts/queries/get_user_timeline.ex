defmodule Openchat.Posts.Queries.GetUserTimeline do

  alias Openchat.Repositories.AgentUserRepository, as: UserRepository

  def run(user_id) do
    UserRepository.get_by_id(user_id)
    |> case do
      nil -> {:error, :user_not_found}
      _user -> {:ok, []}
    end
  end

end
