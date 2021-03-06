defmodule BaseX.ModuleMaker do
  @moduledoc false
  defmacro gen_module(name, abc, a, b, c, cba, vb, vc, vn, check_valid) do
    quote bind_quoted: binding() do
      defmodule name do
        @moduledoc false
        defp chars_for_bits(b), do: Map.fetch!(unquote(vb), b |> bit_size)

        defp bits_for_chars(c) do
          case Map.fetch(unquote(vc), c |> Enum.count()) do
            {:ok, val} -> val
            :error -> decode_error(Enum.join(c))
          end
        end

        defp decode_error(c), do: raise("Invalid input block: " <> c)

        def encode(binary), do: encode(binary, [])
        defp encode(<<>>, acc), do: acc |> Enum.reverse() |> Enum.join()

        defp encode(<<this::unsigned-big-integer-size(unquote(b)), rest::binary>>, acc),
          do: encode(rest, [chars_from(this, unquote(c), []) | acc])

        defp encode(final, acc),
          do:
            encode(<<>>, [
              chars_from(:binary.decode_unsigned(final, :big), chars_for_bits(final), []) | acc
            ])

        defp chars_from(_num, 0, acc), do: acc |> Enum.join()

        defp chars_from(num, count, acc),
          do:
            chars_from(num |> div(unquote(a)), count - 1, [
              elem(unquote(abc), num |> rem(unquote(a))) | acc
            ])

        def decode(binary), do: decode(String.graphemes(binary), [])
        defp decode([], acc), do: acc |> Enum.reverse() |> Enum.join()

        defp decode(cont, acc) do
          {this, rest} = Enum.split(cont, unquote(c))
          decode(rest, [gather_chars(this) | acc])
        end

        defp char_val(c), do: Map.fetch!(unquote(cba), c)

        defp gather_chars(chars), do: chars_to(chars, bits_for_chars(chars), 0)

        defp chars_to([c], final_size, acc) do
          final_acc = acc + char_val(c)
          {:ok, max} = Map.fetch(unquote(vn), final_size)

          if unquote(check_valid) and final_acc > max do
            decode_error("value too large")
          else
            final_acc |> :binary.encode_unsigned(:big) |> pad_chars(final_size)
          end
        end

        defp chars_to([c | rest], final_size, acc),
          do: chars_to(rest, final_size, (acc + char_val(c)) * unquote(a))

        defp pad_chars(b, final_size) when bit_size(b) >= final_size, do: b

        defp pad_chars(b, final_size) when bit_size(b) < final_size,
          do: pad_chars(<<0>> <> b, final_size)
      end
    end
  end
end
