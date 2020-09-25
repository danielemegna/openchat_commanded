defmodule Openchat.Test.Users.Aggregates.UserTest do
 use ExUnit.Case, async: true

 alias Openchat.Users.Aggregates
 alias Openchat.Users.Commands.RegisterUser
 alias Openchat.Users.Events.UserRegistered

  describe "on RegisterUser command" do
    test "emit UserRegistered event" do
      emitted_events = %Aggregates.User{}
      |> given_events([])
      |> executing_command(
        %RegisterUser{username: "username.here", password: "S3cur3", about: "About the user." }
      )

      assert %UserRegistered{
        id: generated_id, username: "username.here",
        password: "S3cur3", about: "About the user."
      } = emitted_events
      assert_valid_uuid generated_id
    end

    test "return error on already used username" do
      error = %Aggregates.User{}
      |> given_events([
        %UserRegistered{id: UUID.uuid4(), username: "used.username", password: "any", about: "any"}
      ])
      |> executing_command(
        %RegisterUser{username: "used.username", password: "another", about: "another" }
      )

      assert error == {:error, :username_already_used}
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

  defp assert_valid_uuid(value) do
    assert Regex.match?(~r/^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i, value)
  end
end
