defmodule Aoc2025.Solutions.Y25.Day06 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
  end

  def part_one(problem) do
    problem
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&process_line/1)
    |> Enum.zip()
    |> Enum.map(&transform_row/1)
    |> Enum.map(&calc_row/1)
    |> Enum.sum()
  end

  def process_line(line) do
    line
    |> String.trim()
    |> String.split()
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

  def part_two(problem) do
    {inputs, [ops]} =
      problem
      |> String.split("\n")
      |> Enum.filter(&(String.trim(&1) != ""))
      |> Enum.split(-1)

    ranges = Regex.scan(~r/([+*]\s*)(?: |$)/, ops, return: :index, capture: :all_but_first)

    inputs =
      inputs
      |> Enum.map(&split_line(&1, ranges))
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(fn lists -> Enum.zip(lists) |> Enum.map(&Tuple.to_list/1) end)
      |> Enum.map(fn lists ->
        Enum.map(lists, fn list ->
          Enum.join(list) |> String.trim() |> String.to_integer()
        end)
      end)

    Enum.zip(inputs, String.split(ops))
    |> Enum.map(&calc_row/1)
    |> Enum.sum()
  end

  defp split_line(line, ranges) do
    for [{start, length}] <- ranges, do: String.slice(line, start, length) |> String.codepoints()
  end
end
