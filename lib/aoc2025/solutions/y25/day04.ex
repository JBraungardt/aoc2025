defmodule Aoc2025.Solutions.Y25.Day04 do
  alias AoC.Input
  alias Aoc2025.Util.Grid

  def parse(input, _part) do
    Input.read!(input)
    |> Grid.new()
  end

  def part_one(problem) do
    changed =
      problem.grid
      |> Enum.filter(fn {pos, val} ->
        val == "@" and can_move?(pos, problem)
      end)
      |> Map.new(fn {pos, _} -> {pos, "X"} end)

    # updated_map =
    Map.merge(problem.grid, changed)
    |> Enum.count(fn {_pos, value} -> value == "X" end)

    # problem = %{problem | grid: updated_map}
  end

  defp can_move?({x, y}, grid) do
    r =
      for dx <- Range.new(x - 1, x + 1), dy <- Range.new(y - 1, y + 1), dx != x or dy != y do
        Grid.get_value(grid, {dx, dy}, ".")
      end

    Enum.count(r, &(&1 != ".")) < 4
  end

  def part_two(problem) do
    remove_accessable(problem, :start, 0)
  end

  defp remove_accessable(_input, 0, total_removed), do: total_removed

  defp remove_accessable(input = %Grid{}, _removed_last_run, total_removed) do
    input =
      Grid.map(input, fn _pos, value ->
        if value == "X", do: ".", else: value
      end)

    changed =
      input.grid
      |> Enum.filter(fn {pos, val} ->
        val == "@" and can_move?(pos, input)
      end)
      |> Map.new(fn {pos, _} -> {pos, "X"} end)

    updated_map = Map.merge(input.grid, changed)
    removed = Enum.count(updated_map, fn {_pos, value} -> value == "X" end)

    remove_accessable(%Grid{input | grid: updated_map}, removed, total_removed + removed)
  end
end
