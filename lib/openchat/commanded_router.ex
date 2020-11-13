defmodule Openchat.CommandedRouter do
  @moduledoc false
  use Commanded.Commands.Router

  alias Openchat.Users
  alias Openchat.Posts

  dispatch [
    Users.Commands.RegisterUser
  ],
  to: Users.Aggregates.User,
  identity: :user_id

  dispatch [
    Posts.Commands.SubmitPost
  ],
  to: Posts.Aggregates.Post,
  identity: :post_id
end
