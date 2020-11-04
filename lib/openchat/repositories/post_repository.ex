defmodule Openchat.Repositories.PostRepository do
  alias Openchat.Posts.Data.Post
  @callback get_by_userid(String.t) :: [Post.t]
  @callback store(Post.t) :: String.t
end
