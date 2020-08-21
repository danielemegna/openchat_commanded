# Openchat

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `openchat` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:openchat, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/openchat](https://hexdocs.pm/openchat).

## Docker dev container

Start it with ..
```
$ docker run --rm -itp 4000:4000 -v $PWD:/app -w /app elixir:alpine sh
```

.. into the container get deps
```
$ mix deps.get
```

.. and run test with
```
$ mix test
```
