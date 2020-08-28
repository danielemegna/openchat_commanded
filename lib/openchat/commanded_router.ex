defmodule Openchat.CommandedRouter do
  @moduledoc false
  use Commanded.Commands.Router

  alias Openchat.Users.Commands
  alias Openchat.Users.Aggregates

  dispatch Commands.RegisterUser, to: Aggregates.User, identity: :username
end
