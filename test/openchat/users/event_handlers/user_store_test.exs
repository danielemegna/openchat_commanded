defmodule Openchat.Users.EventHandlers.UserStoreTest do
  use ExUnit.Case, async: false

  alias Openchat.Users.EventHandlers.UserStore
  alias Openchat.Users.Events.UserRegistered
  alias Openchat.Users.Data.User

  setup do
    UserStore.init()
    :ok
  end

  test "get user from empty repository" do
    assert [] == UserStore.get_all()
  end

	test "store and get user" do
		user_registered_event = %UserRegistered{
			id: UUID.uuid4(),
			username: "shady90",
			password: "$3curePass",
			about: "About shady90."
		} 

		UserStore.handle(user_registered_event, nil)

		expected_stored_user = %User{
			id: user_registered_event.id, 
			username: "shady90",
			password: "$3curePass",
			about: "About shady90."
		}
		assert [expected_stored_user] == UserStore.get_all()
	end

	test "in this repository users are stored in reverse order" do
     shady_user_event = %UserRegistered{
			id: UUID.uuid4(),
       username: "shady90",
       password: "$3curePass",
       about: "About shady90."
     }
     maria_user_event = %UserRegistered{
			id: UUID.uuid4(),
       username: "maria89",
       password: "supeR$3cure",
       about: "About maria89."
     }
     UserStore.handle(shady_user_event, nil)
     UserStore.handle(maria_user_event, nil)
 
     users = UserStore.get_all()
 
     assert users == [
       %User{
         id: maria_user_event.id,
         username: "maria89",
         password: "supeR$3cure",
         about: "About maria89."
       },
       %User{
         id: shady_user_event.id,
         username: "shady90",
         password: "$3curePass",
         about: "About shady90."
       }
     ]
   end
 
end
