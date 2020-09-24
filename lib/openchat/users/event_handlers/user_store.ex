defmodule Openchat.Users.EventHandlers.UserStore do
  use Commanded.Event.Handler,
    application: Openchat.CommandedApp,
    name: __MODULE__,
    consistency: :strong

  require Logger
  alias Openchat.Users.Events.UserRegistered
  
  def init do
    Logger.debug "===== Openchat.Users.EventHandlers.UserStore.init"
    Agent.start_link(fn -> [] end, name: __MODULE__)
    :ok
  end

  def handle(%UserRegistered{} = event, _metadata) do
    Logger.debug "===== Openchat.Users.EventHandlers.UserStore: Event handled!"
    user = Map.from_struct(event)
    Agent.update(__MODULE__, &([user | &1]))
    :ok
  end

  def get_all() do
    Agent.get(__MODULE__, &(&1))
  end
end
