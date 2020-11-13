defmodule Openchat.Users.Commands.RegisterUser do
  @enforce_keys [:user_id, :username, :password, :about]
  defstruct @enforce_keys

  def new(params) do
    params = params |> Map.put(:user_id, UUID.uuid4())
    struct(__MODULE__, params)
  end
end
