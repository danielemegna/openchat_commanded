defmodule Openchat.Users.Aggregates.User do
  defstruct [:username]
  
  alias Openchat.Users.Commands.RegisterUser
  alias Openchat.Users.Events.UserRegistered

  def execute(%__MODULE__{username: username}, %RegisterUser{}) when username != nil, do:
    {:error, :username_already_used}

  def execute(%__MODULE__{}, %RegisterUser{}), do:
    %UserRegistered{id: "fixme", username: "fixme", password: "fixme", about: "fixme"}

  # state mutators

  def apply(%__MODULE__{} = state, %UserRegistered{username: username}) do
    %{state | username: username}
  end

end
