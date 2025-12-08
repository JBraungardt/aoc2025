defmodule Aoc2025.Solutions.Y25.Day05 do
  alias AoC.Input

  def parse(input, _part) do
    [ranges_part, ids_part] =
      Input.read!(input)
      |> String.split("\n\n")

    ids =
      ids_part
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)

    ranges =
      ranges_part
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&line_to_range/1)

    {ids, ranges}
  end

  defp line_to_range(line) do
    [from, to] = Regex.run(~r/^(\d+)-(\d+)$/, line, capture: :all_but_first)

    Range.new(String.to_integer(from), String.to_integer(to))
  end

  def part_one({ids, ranges}) do
    Enum.count(ids, fn id ->
      Enum.any?(ranges, &is_in_range(id, &1))
    end)
  end

  defp is_in_range(value, range), do: value in range

  def part_two({_ids, ranges}) do
    ranges
    |> Enum.sort_by(& &1.first)
    |> merge_ranges()
    |> Enum.map(&Range.size(&1))
    |> Enum.sum()
  end

  defp merge_ranges([first | rest]) do
    rest
    |> Enum.reduce([first], &proces_range/2)
  end

  defp proces_range(range, [current | rest] = result) do
    cond do
      range.first <= current.last + 1 ->
        [Range.new(current.first, max(range.last, current.last)) | rest]

      true ->
        [range | result]
    end
  end
end
