defmodule OpenchatTest do
  use ExUnit.Case
  doctest Openchat

  test "greets the world" do
    assert Openchat.hello() == :world
  end
end
