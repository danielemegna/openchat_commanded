defmodule Openchat.Posts.PostsFacade do

  alias Openchat.Posts.Commands.SubmitPost
  alias Openchat.Posts.Data.Post

  def submit_post(post_data) do
    command = struct(SubmitPost, post_data |> Map.put(:id, UUID.uuid4()))
    command_dispatch_result = Openchat.CommandedApp.dispatch(command, returning: :aggregate_state)
    case command_dispatch_result do
      {:ok, state} ->
        post = %Post{
          id:       command.id,
          user_id:  command.user_id,
          text:     command.text,
          datetime: state.datetime
        }
        {:ok, post}
      {:error, _reason} = error -> error
    end
  end

end
