defmodule Openchat.Users.Commands.RegisterUser do
  @enforce_keys [:username, :password, :about]
  defstruct @enforce_keys

  def new(params) do
    struct(__MODULE__, params)
  end
end
