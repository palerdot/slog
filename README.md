# Slog

Print anything (single/multiple values) as string for debugging. Slog takes a list of values or a single value that is printed as string for debugging. Any value (string, atom, map, list, struct, keyword list ...) except functions can be printed as string with slog.

## Usage:

```elixir
iex> Slog.log ["value is ", {:x, :x, :x}, [key: "value"], {:ok, "Hello Universe!"}]
"value is  {:x, :x, :x} [{:key, value}] {:ok, Hello Universe!}"

iex> Slog.log ["value is ", {:x, :x, :x}, [key: "value"], {:ok, "Hello Universe!"}, %User{age: 29, name: "Arun"}]
"value is  {:x, :x, :x} [{:key, value}] {:ok, Hello Universe!} %User{age: 29, name: Arun}"

# can take an optional delimiter to be printed in between values
iex> Slog.log ["value is ", {:x, :x, :x}, [key: "value"], {:ok, "Hello Universe!"}], delimiter: " --> "
"value is  --> {:x, :x, :x} --> [{:key, value}] --> {:ok, Hello Universe!}"

iex> Slog.log {:hello, "Universe!"}
"{:hello, Universe!}"

iex> Slog.log %{name: "Arun", age: 29}
"%{age: 29, name: Arun}"

iex> Slog.log %{manager: %User{name: "Leonardo", age: 69}}
"%{manager: %User{age: 69, name: Leonardo}}"
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `slog` to your list of dependencies in `mix.exs`:

Slog is an experimental printing module and for now it is recommended to use only in `:dev, :test` environments.

```elixir
def deps do
  [
    {:slog, "~> 0.1.0", only: [:dev, :test]}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/slog](https://hexdocs.pm/slog).

