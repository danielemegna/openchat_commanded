defmodule OpenchatWeb.Supervisor do
  @moduledoc false

  use Supervisor 

  def start_link(arg) do   
    IO.puts "===== OpenchatWeb.Supervisor.start_link"
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do                 
    IO.puts "===== OpenchatWeb.Supervisor.init"
    children = [
      {Plug.Cowboy, scheme: :http, plug: OpenchatWeb.Router, options: [port: 4000]}
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end                               
end
