defmodule Openchat.Posts.Aggregates.Post do
  defstruct [:id, :user_id, :text, :datetime]
  
  alias __MODULE__, as: State
  alias Openchat.Posts.Commands.SubmitPost
  alias Openchat.Posts.Events.PostSubmitted
  alias Openchat.Repositories.AgentUserRepository, as: UserRepository

  def execute(%State{}, %SubmitPost{} = command) do
    case UserRepository.get_by_id(command.user_id) do
      nil -> {:error, :user_not_found}
      _user -> %PostSubmitted{
        post_id: command.post_id,
        user_id: command.user_id,
        text: command.text,
        datetime: DateTime.utc_now()
      }
    end
  end

  # state mutators

  def apply(%State{} = state, %PostSubmitted{} = e) do
    %{ state |
      id: e.post_id,
      user_id: e.user_id,
      text: e.text,
      datetime: e.datetime
    }
  end

end
