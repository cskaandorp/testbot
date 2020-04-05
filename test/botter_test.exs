defmodule BotterTest do
  use ExUnit.Case
  doctest Botter

  test "greets the world" do
    assert Botter.hello() == :world
  end
end
