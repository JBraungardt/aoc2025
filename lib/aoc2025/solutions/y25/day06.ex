defmodule Aoc2025.Solutions.Y25.Day06 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&process_line/1)
    |> Enum.zip()
  end

  def process_line(line) do
    line
    |> String.trim()
    |> String.split()
  end

  def part_one(problem) do
    problem
    |> Enum.map(&transform_row/1)
    |> Enum.map(&calc_row/1)
    |> Enum.sum()
  end

  defp transform_row(row) do
    {list, [op]} =
      Tuple.to_list(row)
      |> Enum.split(-1)

    {Enum.map(list, &String.to_integer/1), op}
  end

  defp calc_row({values, "+"}) do
    Enum.sum(values)
  end

  defp calc_row({values, "*"}) do
    Enum.product(values)
  end

  # def part_two(problem) do
  #   problem
  # end
end
