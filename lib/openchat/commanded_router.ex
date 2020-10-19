defmodule Openchat.CommandedRouter do
  @moduledoc false
  use Commanded.Commands.Router

  alias Openchat.Users
  alias Openchat.Posts

  dispatch [
    Users.Commands.AuthenticateUser,
    Users.Commands.RegisterUser
  ],
  to: Users.Aggregates.User,
  identity: :username

  dispatch [
    Posts.Commands.SubmitPost
  ],
  to: Posts.Aggregates.Post,
  identity: :id
end
