defmodule Aoc2025.Solutions.Y25.Day02 do
  require Integer
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.read!()
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&line_to_range/1)
  end

  defp line_to_range(line) do
    [start, stop] =
      String.split(line, "-")
      |> Enum.map(&String.to_integer/1)

    Range.new(start, stop)
  end

  def part_one(problem) do
    problem
    |> Enum.map(&filter_range/1)
    |> Enum.sum()
  end

  defp filter_range(range) do
    range
    |> Enum.map(&Integer.to_string(&1))
    |> Enum.filter(&Integer.is_even(String.length(&1)))
    |> Enum.filter(fn str ->
      {p1, p2} = String.split_at(str, div(String.length(str), 2))
      p1 == p2
    end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def part_two(problem) do
    problem
    |> Enum.map(&filter_range2/1)
    |> Enum.sum()
  end

  defp filter_range2(range) do
    range
    |> Enum.filter(&(&1 > 9))
    |> Enum.map(&Integer.to_string(&1))
    |> Enum.filter(&check_number/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  defp check_number(number) do
    1..div(String.length(number), 2)
    |> Enum.any?(fn lenght ->
      start = String.slice(number, 0, lenght)
      Regex.match?(~r/^(#{start})\1+$/, number)
    end)
  end
end
