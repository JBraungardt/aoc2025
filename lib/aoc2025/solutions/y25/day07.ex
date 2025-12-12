defmodule Aoc2025.Solutions.Y25.Day07 do
  alias AoC.Input
  alias Aoc2025.Util.Grid

  def parse(input, _part) do
    Input.read!(input)
    |> Grid.new()
  end

  def part_one(%Grid{width: width, height: height} = grid) do
    grid =
      for y <- 0..(height - 1), x <- 0..(width - 1), reduce: grid do
        acc ->
          case Grid.get_value(acc, {x, y}, ".") do
            "." -> check_above(acc, {x, y})
            "^" -> check_split(acc, {x, y})
            _ -> acc
          end
      end

    Enum.count(grid.grid, fn {{x, y}, value} ->
      case value do
        "^" ->
          case Grid.get_value(grid, {x, y - 1}, ".") do
            "S" -> true
            _ -> false
          end

        _ ->
          false
      end
    end)
  end

  defp check_above(grid, {x, y}) do
    case Grid.get_value(grid, {x, y - 1}, ".") do
      "S" -> Grid.set_value(grid, {x, y}, "S")
      _ -> grid
    end
  end

  defp check_split(grid, {x, y}) do
    case Grid.get_value(grid, {x, y - 1}, ".") do
      "S" ->
        grid
        |> Grid.set_value({x - 1, y}, "S")
        |> Grid.set_value({x + 1, y}, "S")

      _ ->
        grid
    end
  end

  def part_two(problem) do
    problem
  end
end
