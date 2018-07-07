defmodule Slog do
  @moduledoc """
  Documentation for Slog.

  Print anything (single/multiple values) as string for debugging. Slog takes a list of values or a single value that is printed as string for debugging. 
  Any value (string, atom, map, list, struct, keyword list ...) except functions can be printed as string with slog.
  """
  @default_options [delimiter: " "]

  @doc """
  logs given list of data, takes optional keyword list

  ## Examples

      # define user struct 
      defmodule User do
        defstruct name: "Arun", age: 29
      end

      # iex> import User
      # User

      iex> Slog.log ["value is ", {:x, :x, :x}, [key: "value"], {:ok, "Hello Universe!"}]
      "value is  {:x, :x, :x} [{:key, value}] {:ok, Hello Universe!}"

      iex> Slog.log ["value is ", {:x, :x, :x}, [key: "value"], {:ok, "Hello Universe!"}, %User{age: 29, name: "Arun"}]
      "value is  {:x, :x, :x} [{:key, value}] {:ok, Hello Universe!} %User{age: 29, name: Arun}"

      iex> Slog.log ["value is ", {:x, :x, :x}, [key: "value"], {:ok, "Hello Universe!"}], delimiter: " --> "
      "value is  --> {:x, :x, :x} --> [{:key, value}] --> {:ok, Hello Universe!}"

      iex> Slog.log {:hello, "Universe!"}
      "{:hello, Universe!}"

      iex> Slog.log %{name: "Arun", age: 29}
      "%{age: 29, name: Arun}"

      iex> Slog.log %{manager: %User{name: "Leonardo", age: 69}}
      "%{manager: %User{age: 69, name: Leonardo}}"
  """
  def log(data, opts) when is_list(data) do
    
    # v1 -> syncronous processing
    logged = Enum.map data, &process_elements/1

    # v2 -> async processing
    # logged = 
    #   data
    #   |> Stream.map(&async_query/1)
    #   |> Enum.map(&get_result/1)

    # construct options for logging
    options = Keyword.merge(@default_options, opts)
    delimiter = Keyword.fetch!(options, :delimiter)

    # log the final result
    Enum.join(logged, delimiter)
  end
  def log(data) when is_list(data) do
    log(data, @default_options)
  end
  def log(d) do
    log([d], @default_options)
  end

  # called when not a valid argument
  def log() do
    raise SlogArgumentError
  end

  # private functions

  # async processing stuffs
  # helper function to make async query
  # defp async_query(query) do
  #   caller = self()
  #   spawn(fn ->
  #     send(caller, {:slogged, process_elements(query)})
  #   end)
  # end 

  # # helper function to get result
  # defp get_result(_) do
  #   receive do
  #     {:slogged, result} -> result
  #   end
  # end

  # helper function to process elements
  defp process_elements(d) do
    try do
      any_to_string(d)
    catch
      d ->
        IO.inspect d
        raise SlogInvalidType, message: "Cannot log given value; probably a function! please recheck the values passed."
    end
  end

  # converts all data types to string
  # map checking; matches any map
  defp any_to_string(%{} = m) do
    s = 
      m
      |> Map.to_list()
      |> Stream.map( 
          fn {k, v} -> 
            cond do
              is_atom(k) && k != :__struct__ ->
                "#{k}: #{any_to_string(v)}"
              k == :__struct__ ->
                ""
              true ->
                "#{k} => #{any_to_string(v)}"
            end
          end
        )
      |> Stream.reject(fn e -> String.length(e) == 0 end)
      |> Enum.join(", ")

    # check if it is a struct
    struct_name =
      case Map.fetch(m, :__struct__) do
        {:ok, name} ->
          any_to_string(name)
          |> String.split(".")
          |> List.last()
        _ ->
          ""
      end
      
    # log in map format
    # "%{#{s}}"
    ~s(%#{struct_name}{#{s}})
  end
  # list checking
  defp any_to_string(elem) when is_list(elem) do
    s = 
      elem
      |> Enum.map(&any_to_string/1)
      |> Enum.join(", ")

    "[#{s}]"
  end
  # tuple check
  defp any_to_string(elem) when is_tuple(elem) do
    s = 
      Tuple.to_list(elem)
      |> Enum.map(&any_to_string/1)
      |> Enum.join(", ")
    "{#{s}}"
  end
  # binary check => binary/number/float/boolean
  defp any_to_string(elem) when is_binary(elem) or is_number(elem) or is_float(elem) or is_boolean(elem) do
    to_string(elem)
  end
  # atom check
  defp any_to_string(elem) when is_atom(elem) do
    ":" <> to_string(elem)
  end

  # does not match any of the above guard conditions
  # raise an error
  defp any_to_string(elem) do
    throw(elem)
  end
end

# ref: https://elixir-lang.org/getting-started/try-catch-and-rescue.html#errors
defmodule SlogArgumentError do
  defexception message: "invalid argument to log. Expecting a list ...." 
end

defmodule SlogInvalidType do
  defexception message: "cannot log given element"
end
