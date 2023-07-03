defmodule Babel.Helper do
  @moduledoc false

  def map_and_reduce_results(data, reducer) when is_function(reducer, 1) do
    {ok_or_error, list} =
      Enum.reduce(data, {:ok, []}, fn element, {ok_or_error, list} ->
        case reducer.(element) do
          {^ok_or_error, value} ->
            {ok_or_error, [value | list]}

          {:error, error} when ok_or_error == :ok ->
            {:error, [error]}

          {:ok, _value} when ok_or_error == :error ->
            {:error, list}
        end
      end)

    {ok_or_error, Enum.reverse(list)}
  end
end
