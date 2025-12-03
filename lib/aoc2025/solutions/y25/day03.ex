defmodule Aoc2025.Solutions.Y25.Day03 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&line_to_list_of_ints/1)
  end

  defp line_to_list_of_ints(line) do
    line
    |> String.graphemes()
    |> Enum.map(&String.to_integer(&1))
  end

  def part_one(problem) do
    problem
    |> Enum.map(&find_joltage/1)
    |> Enum.sum()
  end

  defp find_joltage(list) do
    first =
      list
      |> List.delete_at(-1)
      |> Enum.max()

    index = Enum.find_index(list, &(&1 == first))

    second =
      Enum.drop(list, index + 1)
      |> Enum.max()

    "#{first}#{second}" |> String.to_integer()
  end

  # def part_two(problem) do
  #   problem
  # end
end
