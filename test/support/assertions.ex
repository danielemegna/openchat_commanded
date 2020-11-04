defmodule Openchat.TestSupport.Assertions do
  import ExUnit.Assertions, only: [assert: 1]

  def assert_valid_uuid(value) do
    assert Regex.match?(~r/^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i, value)
  end

  def assert_datetime_format(value) do
    assert Regex.match?(~r/^((19|20)[0-9][0-9])[-](0[1-9]|1[012])[-](0[1-9]|[12][0-9]|3[01])[T]([01][0-9]|[2][0-3])[:]([0-5][0-9])[:]([0-5][0-9])Z$/i, value)
  end
end
