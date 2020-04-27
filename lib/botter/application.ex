defmodule Botter.Application do

  alias Botter.Bot
  alias NimbleCSV.RFC4180, as: CSV

  def start(_type, args) do

    { :ok, _ } = Application.ensure_all_started(:hound)

    tokens_file = args[:tokens]

    # to get access and exit tokens
    tokens = case File.exists?(tokens_file) do
      true -> read_csv_file(tokens_file)
      _ -> nil
    end

    delay = args[:delay]
    offset = args[:offset]
    n = args[:n]
    env = args[:env]

    bots = 
      tokens
      |> Enum.map(fn [access, _exit] -> { access, Enum.random([1, 7]) } end)
      |> Enum.slice(offset, n)

    children = Enum.map Enum.with_index(bots), fn {{ access_token, ideology }, i} ->
      Supervisor.child_spec(
        { Bot, %{ access_token: access_token, ideology: ideology, env: env, delay: delay }}, 
        id: { Bot, i }, restart: :temporary
      )
    end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Botter.Supervisor]
    # Supervisor.start_link(children, opts)
    Supervisor.start_link(children, opts)
  end


  defp read_csv_file(filepath, omit_header \\ false) do
    contents =
        filepath
        |> File.read!()
        |> CSV.parse_string
    result = if omit_header do
        [ _ | tail ] = contents
        tail
    else
        contents
    end
    result
  end

end

  
  
  
  
  