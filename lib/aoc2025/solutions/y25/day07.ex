defmodule Aoc2025.Solutions.Y25.Day07 do
  alias AoC.Input
  alias Aoc2025.Util.Grid

  def parse(input, _part) do
    Input.read!(input)
  end

  def part_one(problem) do
    %Grid{height: height, width: width} = grid = Grid.new(problem)

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
    [start | rest] = String.split(problem)

    [{start_col, _}] = Regex.run(~r/[^.]/, start, return: :index)

    splitters =
      Enum.map(rest, fn row ->
        row
        |> String.to_charlist()
        |> Enum.with_index()
        |> Enum.filter(&(elem(&1, 0) == ?^))
        |> MapSet.new(&elem(&1, 1))
      end)

    initial_beem = %{start_col => 1}

    Enum.reduce(splitters, initial_beem, &process_row/2)
    |> Enum.sum_by(&elem(&1, 1))
  end

  defp process_row(row_splitters, beams) do
    Enum.reduce(row_splitters, beams, &maybe_split/2)
  end

  defp maybe_split(col, beams) do
    case Map.pop(beams, col) do
      {nil, map} ->
        map

      {count, map} ->
        Map.merge(
          map,
          %{
            (col + 1) => count,
            (col - 1) => count
          },
          fn _k, a, b -> a + b end
        )
    end
  end
end
