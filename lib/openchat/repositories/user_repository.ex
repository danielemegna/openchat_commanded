defmodule Openchat.Repositories.UserRepository do
  alias Openchat.Users.Data.User
  @callback get_all() :: [User.t]
  @callback get_by_username(String.t) :: User.t
  @callback get_by_id(String.t) :: User.t
  @callback store(User.t) :: :ok
end
