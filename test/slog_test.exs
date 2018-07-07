defmodule SlogTest do
  use ExUnit.Case
  doctest Slog

  test ":atom ==> string" do
    assert Slog.log :atom == ":atom"
  end
end
