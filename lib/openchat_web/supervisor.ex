defmodule OpenchatWeb.Supervisor do
  @moduledoc false
  use Supervisor 

  require Logger

  def start_link(arg) do   
    Logger.debug "===== OpenchatWeb.Supervisor.start_link"
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do                 
    Logger.debug "===== OpenchatWeb.Supervisor.init"
    children = [
      {Plug.Cowboy, scheme: :http, plug: OpenchatWeb.Router, options: [port: 4000]}
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end                               
end
