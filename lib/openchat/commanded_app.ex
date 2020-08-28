defmodule Openchat.CommandedApp do
  @moduledoc false

  use Commanded.Application,
    otp_app: :openchat,
    event_store: [adapter: Commanded.EventStore.Adapters.InMemory]

  router Openchat.CommandedRouter
end
