


brew cask list
brew cask list | grep chrome
brew cask install chromedriver
brew cask reinstall chromedriver



# Botter

1. install chrome-driver
2. start chromedriver:
$ chromedriver
3. start bots:
/botter $ iex -S mix
> mix start --env=local --tokens=./session_8.csv --delay=0 0 18


**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `botter` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:botter, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/botter](https://hexdocs.pm/botter).

