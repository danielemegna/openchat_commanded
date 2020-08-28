defmodule Openchat.Supervisor do
  @moduledoc false

  use Supervisor 

  def start_link(arg) do   
    IO.puts "===== Openchat.Supervisor.start_link"
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do                 
    IO.puts "===== Openchat.Supervisor.init"
    children = [
      Openchat.CommandedApp
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end                               
end
