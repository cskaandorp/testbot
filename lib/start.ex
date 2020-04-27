defmodule Mix.Tasks.Start do
    use Mix.Task
  
    # mix start --env=local --tokens=/Users/casper/Desktop/session_8.csv --delay=2 11 1
    def run(args) do
        { parsed, args, _invalid } = OptionParser.parse(
            args, 
            strict: [env: :string, tokens: :string, delay: :integer]
        )

        parsed = Enum.into(parsed, %{})
        
        parsed = case Map.has_key? parsed, :env do
            false -> Map.put(parsed, :env, "local")
            _ -> parsed
        end

        parsed = case Map.has_key? parsed, :delay do
            false -> Map.put(parsed, :delay, 0)
            _ -> parsed
        end

        parsed = case args do
            [] -> Map.merge(
                parsed, 
                %{ offset: 0, n: 25}
            )
            [n] -> Map.merge(
                parsed, 
                %{ offset: 0, n: String.to_integer(n)}
            )
            [o, n | _] -> Map.merge(
                parsed, 
                %{ offset: String.to_integer(o), n: String.to_integer(n)}
            )
        end

        Botter.Application.start(:whatever, parsed)
        Process.sleep(:infinity)
    end

end