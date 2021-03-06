defmodule Openchat.Posts.PostsFacade do

  alias Openchat.Posts.{Commands,Queries,Data}
  alias Openchat.CommandedApp

  def submit_post(post_data) do
    command = Commands.SubmitPost.new(post_data)
    command_dispatch_result = CommandedApp.dispatch(command, returning: :aggregate_state)
    case command_dispatch_result do
      {:ok, state} ->
        post = %Data.Post{
          id:       state.id,
          user_id:  state.user_id,
          text:     state.text,
          datetime: state.datetime
        }
        {:ok, post}
      {:error, _reason} = error -> error
    end
  end

  def get_timeline(user_id) do
    Queries.GetUserTimeline.run(user_id)
  end

end
