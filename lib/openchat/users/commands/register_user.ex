defmodule Openchat.Users.Commands.RegisterUser do
  @enforce_keys [:id, :username, :password, :about]
  defstruct @enforce_keys

  def new(params) do
    params = params |> Map.put(:id, UUID.uuid4())
    struct(__MODULE__, params)
  end
end
