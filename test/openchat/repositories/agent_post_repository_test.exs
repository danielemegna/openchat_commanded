defmodule Openchat.Repositories.AgentPostRepositoryTest do
  use ExUnit.Case
  alias Openchat.Repositories.AgentPostRepository
  alias Openchat.Posts.Data.Post

  setup do
    start_supervised!(AgentPostRepository)
    :ok
  end

  test "get post from empty repository" do
    assert [] == AgentPostRepository.get_by_userid('not-present')
  end

  test "store and get post" do
    post_id = UUID.uuid4()
    now_datetime = DateTime.utc_now()
    post = %Post{
      id: post_id,
      user_id: "user.id",
      text: "Post text.",
      datetime: now_datetime
    }

    :ok = AgentPostRepository.store(post)

    expected_stored_post = %Post{
      id: post_id,
      user_id: "user.id",
      text: "Post text.",
      datetime: now_datetime
    }
    assert [expected_stored_post] == AgentPostRepository.get_by_userid("user.id")
    assert [] == AgentPostRepository.get_by_userid('not-present')
  end

  test "in this repository posts are stored in reverse order" do
    first_post = %Post{
      id: UUID.uuid4(),
      user_id: "user.id",
      text: "Post text.",
      datetime: DateTime.utc_now()
    }
    :ok = AgentPostRepository.store(first_post)

    second_post = %Post{
      id: UUID.uuid4(),
      user_id: "user.id",
      text: "Second post text.",
      datetime:  DateTime.utc_now()
    }
    :ok = AgentPostRepository.store(second_post)

    posts = AgentPostRepository.get_by_userid("user.id")

    assert posts == [second_post, first_post]
  end

end
