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

  def part_two(problem) do
    problem
    |> Enum.map(&find_joltage2/1)
    |> Enum.map(&Integer.undigits(&1))
    |> Enum.sum()
  end

  defp find_joltage2(list) do
    11..0//-1
    |> Enum.reduce({list, []}, fn split_index, acc ->
      find_max_in_sublist(split_index, acc)
    end)
    |> elem(1)
    |> Enum.reverse()
  end

  defp find_max_in_sublist(split_index, {list, result}) do
    max =
      list
      |> Enum.reverse()
      |> Enum.split(split_index)
      |> elem(1)
      |> Enum.max()

    index_of_max = Enum.find_index(list, &(&1 == max))
    rest_list = Enum.drop(list, index_of_max + 1)

    {rest_list, [max | result]}
  end

  # Gemini AI solution
  #
  # def part_two(problem) do
  #     problem
  #     |> Enum.map(&solve_row/1)
  #     |> Enum.sum()
  #   end

  #   # Orchestrates finding exactly 12 digits
  #   defp solve_row(list) do
  #     list
  #     |> find_greedy_digits(12)
  #     |> Integer.undigits()
  #   end

  #   # Base case: We need 0 more digits, return empty list
  #   defp find_greedy_digits(_list, 0), do: []

  #   # Recursive case
  #   defp find_greedy_digits(list, count_needed) do
  #     # 1. Determine the "Safe Window"
  #     # We must leave (count_needed - 1) items for the future steps.
  #     # Therefore, we can only search in the first (Total - Remaining + 1) items.
  #     search_window_size = length(list) - count_needed + 1

  #     {search_area, _} = Enum.split(list, search_window_size)

  #     # 2. Find the max value in that valid window
  #     max_val = Enum.max(search_area)

  #     # 3. Find the index of that max value (to drop everything before it)
  #     # We use find_index to ensure we stop at the *first* instance of the max
  #     index = Enum.find_index(list, &(&1 == max_val))

  #     # 4. Drop the used elements and recurse
  #     # index + 1 ensures we drop the max_val itself too
  #     remaining_list = Enum.drop(list, index + 1)

  #     [max_val | find_greedy_digits(remaining_list, count_needed - 1)]
  #   end
end
