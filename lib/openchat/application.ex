defmodule Openchat.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    IO.puts "===== Application.start"
    children = [
      Openchat.Supervisor,
      OpenchatWeb.Supervisor
    ]

    opts = [strategy: :one_for_one, name: Openchat.MainSupervisor]
    Supervisor.start_link(children, opts)
  end
end
