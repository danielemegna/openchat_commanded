defmodule Openchat.Users.EventHandlers.UserRegistered do
  use Commanded.Event.Handler,
    application: Openchat.CommandedApp,
    name: __MODULE__,
    consistency: :eventual

  require Logger
  alias Openchat.Repositories.AgentUserRepository, as: UserRepository
  alias Openchat.Users.Events
  alias Openchat.Users.Data
  
  def handle(%Events.UserRegistered{} = event, _metadata) do
    user = struct(Data.User, Map.from_struct(event))
    UserRepository.store(user)
    :ok
  end
end
