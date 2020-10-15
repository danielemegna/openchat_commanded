defmodule Openchat.TestSupport.Assertions do
  import ExUnit.Assertions, only: [assert: 1]

  def assert_valid_uuid(value) do
    assert Regex.match?(~r/^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i, value)
  end
end
