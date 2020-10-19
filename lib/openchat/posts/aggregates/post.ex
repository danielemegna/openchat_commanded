defmodule Openchat.Posts.Aggregates.Post do
  defstruct [:id, :user_id, :text, :datetime]
  
  alias __MODULE__, as: State
  alias Openchat.Posts.Commands.SubmitPost
  alias Openchat.Repositories.AgentUserRepository, as: UserRepository

  def execute(%State{}, %SubmitPost{user_id: user_id}) do
    case UserRepository.get_by_id(user_id) do
      nil -> {:error, :user_not_found}
      _ -> :ok
    end
  end

  # state mutators

end
