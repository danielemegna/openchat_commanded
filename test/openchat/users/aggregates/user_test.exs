defmodule Openchat.Test.Users.Aggregates.UserTest do
 use ExUnit.Case, async: true

 alias Openchat.Users.Aggregates
 alias Openchat.Users.Commands.RegisterUser
 alias Openchat.Users.Events.UserRegistered

  describe "on RegisterUser command" do
    test "emit UserRegistered event" do
      user_id = UUID.uuid4()
      emitted_events = %Aggregates.User{}
      |> given_events([])
      |> executing_command(
        %RegisterUser{
          user_id: user_id, username: "username.here",
          password: "S3cur3", about: "About the user."
        }
      )

      assert %UserRegistered{
        user_id: user_id, username: "username.here",
        password: "S3cur3", about: "About the user."
      } = emitted_events
    end
  end

  defp given_events(aggregate, events) do
    Enum.reduce(events, aggregate, fn(event, aggregate) ->
      apply(aggregate.__struct__, :apply, [aggregate, event])
    end)
  end

  defp executing_command(aggregate, command) do
    apply(aggregate.__struct__, :execute, [aggregate, command])
  end
end
