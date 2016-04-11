defmodule BaseX do

  @moduledoc """
  coding for arbitrary alphabets and block sizes
  """

  @doc """
  prepare a coding module

  Returns the name of the module.

  The resulting module will appear in the BaseX namespace and have `encode`
  and `decode` functions available.

  Example:

  ```
  BaseX.prepare_module("Base2", "01", 4)

  BaseX.Base2.encode("Hi!") # "010010000110100100100001"
  BaseX.Base2.decode("010010000110100100100001") # "Hi!"
  ```

  These functions are only suitable for complete messages.
  Streaming applications should manage their own incomplete message state.

  The supplied module name should be both valid (by Elixir rules) and unique.
  Care should be taken when regenereating modules with the same name.

  Alphabets may be defined by `{"t","u","p","l","e"}`, `"string"`, `'charlist'` or
  `["l","i","s","t"]` as desired.
  """
  @spec prepare_module(String.t, binary | list | tuple, pos_integer) :: term
  def prepare_module(name,abc,bs) when is_tuple(abc)  do
    full_name = Module.concat("BaseX",name)
    generate_module(full_name,abc,bs)
    case Code.ensure_compiled(full_name) do
      {:module, module} -> module
      {:error, why}     -> raise(why)
    end
  end
  def prepare_module(name,[a|bc], bs) when is_bitstring(a),   do: prepare_module(name,[a|bc] |> List.to_tuple, bs)
  def prepare_module(name,[a|bc], bs) when is_integer(a),     do: prepare_module(name,[a|bc] |> Enum.map(&:binary.encode_unsigned/1) |> List.to_tuple, bs)
  def prepare_module(name,abc, bs) when is_binary(abc),       do: prepare_module(name,abc |> String.split("") |> Enum.filter(fn c -> c != "" end), bs)

  defp generate_module(name,abc, s) do
      require BaseX.ModuleMaker
      a = tuple_size(abc)
      b = s * 8
      c = chars_for_bits(b,a)
      {vb, vc, vn} = valid_sizes(b, a, {%{}, %{}, %{}})
      BaseX.ModuleMaker.gen_module(name,Macro.escape(abc),a,b,c,abc |> index_map_from_tuple |> Macro.escape, Macro.escape(vb), Macro.escape(vc), Macro.escape(vn))
  end

  defp chars_for_bits(b,a), do: (b/:math.log2(a)) |> Float.ceil |> trunc
  defp max_num_for_bits(b), do: (:math.pow(2,b) - 1) |> trunc
  defp valid_sizes(0,_a, acc), do: acc
  defp valid_sizes(b, a, acc) do
      c = chars_for_bits(b,a)
      valid_sizes(b-8, a, {Map.put(elem(acc,0),b,c), Map.put(elem(acc,1),c,b), Map.put(elem(acc,2),b, b |> max_num_for_bits)})
  end

  defp index_map_from_tuple(tuple), do: map_elements(tuple |> Tuple.to_list, 0, %{})
  defp map_elements([], _index, map), do: map
  defp map_elements([e|rest], index, map), do: map_elements(rest, index+1, Map.put(map, e, index))

end
