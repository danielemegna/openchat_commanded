defmodule Openchat.Posts.PostsFacade do

  alias Openchat.Posts.Commands.SubmitPost
  alias Openchat.Posts.Data.Post

  def submit_post(post_data) do
    command = SubmitPost.new(post_data)
    command_dispatch_result = Openchat.CommandedApp.dispatch(command, returning: :aggregate_state)
    case command_dispatch_result do
      {:ok, state} ->
        post = %Post{
          id:       state.id,
          user_id:  state.user_id,
          text:     state.text,
          datetime: state.datetime
        }
        {:ok, post}
      {:error, _reason} = error -> error
    end
  end

end
