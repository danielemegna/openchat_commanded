defmodule Openchat.Application do
  @moduledoc false
  use Application

  require Logger

  def start(_type, _args) do
    Logger.debug "===== Application.start"
    children = [
      Openchat.Supervisor,
      OpenchatWeb.Supervisor
    ]

    opts = [strategy: :one_for_one, name: Openchat.MainSupervisor]
    Supervisor.start_link(children, opts)
  end
end
