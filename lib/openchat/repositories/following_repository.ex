defmodule Openchat.Repositories.FollowingRepository do
  alias Openchat.Users.Data.Following
  @callback get_by_follower_id(String.t) :: [Following.t];
  @callback store(Following.t) :: :ok
end
