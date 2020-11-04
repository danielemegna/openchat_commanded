defmodule Openchat.Supervisor do
  @moduledoc false
  use Supervisor 

  require Logger

  def start_link(arg) do   
    Logger.debug "===== Openchat.Supervisor.start_link"
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do                 
    Logger.debug "===== Openchat.Supervisor.init"
    children = [
      Openchat.CommandedApp,
      Openchat.Repositories.AgentUserRepository,
      Openchat.Users.EventHandlers.StoreUser,
      Openchat.Repositories.AgentPostRepository,
      Openchat.Posts.EventHandlers.StorePost
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end                               
end
