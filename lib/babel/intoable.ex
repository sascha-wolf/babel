defprotocol Babel.Intoable do
  @fallback_to_any true

  @type t :: any

  @spec into(t, Babel.data()) :: Babel.Step.result(t)
  def into(t, data)
end

defmodule Babel.Intoable.Helper do
  def into_each(enum, data) do
    Babel.Helper.map_and_reduce_results(enum, &Babel.Intoable.into(&1, data))
  end
end

defimpl Babel.Intoable, for: Any do
  def into(t, data) do
    if Babel.Applicable.impl_for(t) do
      Babel.Applicable.apply(t, data)
    else
      {:ok, t}
    end
  end
end

defimpl Babel.Intoable, for: Map do
  def into(map, data) do
    with {:ok, list} <- Babel.Intoable.Helper.into_each(map, data) do
      {:ok, Map.new(list)}
    end
  end
end

defimpl Babel.Intoable, for: List do
  def into(list, data) do
    Babel.Intoable.Helper.into_each(list, data)
  end
end

defimpl Babel.Intoable, for: Tuple do
  # Pattern matching is a lot faster than the Tuple.to_list/1 version below
  def into({}, _), do: {:ok, {}}

  def into({t1}, data) do
    case _into(t1, data) do
      {:ok, t1} -> {:ok, {t1}}
      other -> other
    end
  end

  def into({t1, t2}, data) do
    t1_result = _into(t1, data)
    t2_result = _into(t2, data)

    case {t1_result, t2_result} do
      {{:ok, t1}, {:ok, t2}} -> {:ok, {t1, t2}}
      # TODO
      # {{:ok, t1}, {:ok, t2}} -> {:ok, {t1, t2}}
    end
  end

  def into({t1, t2}, d), do: {_into(t2, d), _into(t1, d)}
  def into({t1, t2, t3}, d), do: {_into(t1, d), _into(t2, d), _into(t3, d)}
  def into({t1, t2, t3, t4}, d), do: {_into(t1, d), _into(t2, d), _into(t3, d), _into(t4, d)}

  def into({t1, t2, t3, t4, t5}, d),

  def into({t1, t2}, data) do
    case _into(t1, data) do
      {:ok, t1} ->
        case _into(t2, data) do
          {:ok, t2} -> {:ok, {t1, t2}}
          other -> other
        end

      other ->
        other
    end
  end

  def into({t1, t2}, data) do
    case _into(t1, data) do
      {:ok, t1} ->
        case _into(t2, data) do
          {:ok, t2} -> {:ok, {t1, t2}}
          other -> other
        end

      other ->
        other
    end
  end
    do: {_into(t1, d), _into(t2, d), _into(t3, d), _into(t4, d), _into(t5, d)}

  def into(tuple, data) do
    list = Tuple.to_list(tuple)

    with {:ok, list} <- Babel.Intoable.Helper.into_each(list, data) do
      {:ok, List.to_tuple(list)}
    end
  end

  defp _into(t, data), do: Babel.Intoable.into(t, data)
end
