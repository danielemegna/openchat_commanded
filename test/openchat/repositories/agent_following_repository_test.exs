defmodule Openchat.Repositories.AgentFollowingRepositoryTest do
  use ExUnit.Case
  alias Openchat.Repositories.AgentFollowingRepository
  alias Openchat.Users.Data.Following

  setup do
    start_supervised!(AgentFollowingRepository)
    :ok
  end

  test "get from empty repository" do
    assert [] == AgentFollowingRepository.get_by_follower_id(UUID.uuid4())
  end

  test "store and get by follower id" do
    first_user_id = UUID.uuid4()
    second_user_id = UUID.uuid4()
    third_user_id = UUID.uuid4()

    first_following = %Following{follower_id: first_user_id, followee_id: second_user_id}
    :ok = AgentFollowingRepository.store(first_following)
    second_following = %Following{follower_id: second_user_id, followee_id: first_user_id}
    :ok = AgentFollowingRepository.store(second_following)
    third_following = %Following{follower_id: second_user_id, followee_id: third_user_id}
    :ok = AgentFollowingRepository.store(third_following)

    assert [first_following] == AgentFollowingRepository.get_by_follower_id(first_user_id)
    assert [third_following, second_following] == AgentFollowingRepository.get_by_follower_id(second_user_id)
    assert [] == AgentFollowingRepository.get_by_follower_id(third_user_id)
    assert [] == AgentFollowingRepository.get_by_follower_id(UUID.uuid4())
  end

end
