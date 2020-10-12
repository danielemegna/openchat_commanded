defmodule Openchat.Repositories.AgentUserRepositoryTest do
  use ExUnit.Case 
  alias Openchat.Repositories.AgentUserRepository
  alias Openchat.Users.Data.User
  #import Openchat.Support.AssertionsHelper

  setup do
    AgentUserRepository.start_link([])
    :ok
  end


  test "get user from empty repository" do
    assert [] == AgentUserRepository.get_all()
    assert nil == AgentUserRepository.get_by_username("not_present")
    assert nil == AgentUserRepository.get_by_id("not_present")
  end

  test "store and get user" do
    user_id = UUID.uuid4()
    user = %User{
      id: user_id,
      username: "shady90",
      password: "$3curePass",
      about: "About shady90."
    }

    AgentUserRepository.store(user)

    expected_stored_user = %User{
      id: user_id,
      username: "shady90",
      password: "$3curePass",
      about: "About shady90."
    }

    assert expected_stored_user == AgentUserRepository.get_by_username("shady90")
    assert expected_stored_user == AgentUserRepository.get_by_id(user_id)
    assert [expected_stored_user] == AgentUserRepository.get_all()
    assert nil == AgentUserRepository.get_by_username("not_present")
    assert nil == AgentUserRepository.get_by_id("not_present")
  end

  test "in this repository users are stored in reverse order" do
    shady_id = UUID.uuid4()
    shady_user = %User{
      id: shady_id,
      username: "shady90",
      password: "$3curePass",
      about: "About shady90."
    }
    AgentUserRepository.store(shady_user)
    maria_id = UUID.uuid4()
    maria_user = %User{
      id: maria_id,
      username: "maria89",
      password: "supeR$3cure",
      about: "About maria89."
    }
    AgentUserRepository.store(maria_user)

    users = AgentUserRepository.get_all()

    assert users == [
      %User{
        id: maria_id,
        username: "maria89",
        password: "supeR$3cure",
        about: "About maria89."
      },
      %User{
        id: shady_id,
        username: "shady90",
        password: "$3curePass",
        about: "About shady90."
      }
    ]
  end

end
