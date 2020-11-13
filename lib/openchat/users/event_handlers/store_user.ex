defmodule Openchat.Users.EventHandlers.StoreUser do
  use Commanded.Event.Handler,
    application: Openchat.CommandedApp,
    name: __MODULE__,
    consistency: :eventual

  alias Openchat.Repositories.AgentUserRepository, as: UserRepository
  alias Openchat.Users.Events
  alias Openchat.Users.Data
  
  def handle(%Events.UserRegistered{} = event, _metadata) do
    user = %Data.User{
      id:       event.user_id,
      username: event.username,
      password: event.password,
      about:    event.about
    }
    UserRepository.store(user)
    :ok
  end
end
