defmodule Day9.Grid do
  defstruct [:values, :width, :height]

  def new(width, height) do
    %__MODULE__{values: %{}, width: width, height: height}
  end

  def add_line(%__MODULE__{} = grid, [[x1, y1], [x2, y1]]) do
    # grid
    # |> add_point({x1, y1}, "#")
    # |> add_point({x2, y1}, "#")

    r =
      if x1 < x2 do
        Range.new(x1, x2)
      else
        Range.new(x2, x1)
      end

    for x <- r, reduce: grid do
      acc -> add_point(acc, {x, y1}, "X")
    end
  end

  def add_line(%__MODULE__{} = grid, [[x1, y1], [x1, y2]]) do
    # grid
    # |> add_point({x1, y1}, "#")
    # |> add_point({x1, y2}, "#")

    r =
      if y1 < y2 do
        Range.new(y1, y2)
      else
        Range.new(y2, y1)
      end

    for y <- r, reduce: grid do
      acc -> add_point(acc, {x1, y}, "X")
    end
  end

  def add_point(%__MODULE__{values: values} = grid, pos, char) do
    %{grid | values: Map.put(values, pos, char)}
  end

  def flood_fill(grid, start_pos) do
    fill(grid, [start_pos], MapSet.new())
  end

  defp fill(%__MODULE__{} = grid, [], _visited) do
    grid
  end

  defp fill(%__MODULE__{} = grid, [pos | rest], %MapSet{} = visited) do
    IO.inspect(MapSet.size(visited))

    if MapSet.member?(visited, pos) or Map.get(grid.values, pos) == "X" do
      fill(grid, rest, visited)
    else
      new_values = Map.put(grid.values, pos, "X")
      visited = MapSet.put(visited, pos)

      {x, y} = pos
      neighbors = [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]

      fill(%{grid | values: new_values}, rest ++ neighbors, visited)
    end
  end
end

defimpl Inspect, for: Day9.Grid do
  def inspect(grid, _opts) do
    import Inspect.Algebra

    rows =
      for y <- 0..(grid.height - 1) do
        line = for x <- 0..(grid.width - 1), do: to_string(grid.values[{x, y}] || ".")
        Enum.join(line)
      end

    concat(["#Grid<#{grid.width}x#{grid.height}>\n", Enum.join(rows, "\n")])
  end
end

defmodule Aoc2025.Solutions.Y25.Day09 do
  alias AoC.Input
  alias Day9.Grid

  def parse(input, _part) do
    Input.read!(input)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp get_all_pairs([]), do: []

  defp get_all_pairs([head | tail]) do
    Enum.map(tail, &{head, &1}) ++ get_all_pairs(tail)
  end

  def part_one(problem) do
    problem
    |> get_all_pairs()
    |> Enum.map(&calc_area/1)
    |> Enum.sort(:desc)
    |> List.first()
  end

  defp calc_area({[x1, y1], [x2, y2]}) do
    (abs(x1 - x2) + 1) * (abs(y1 - y2) + 1)
  end

  def part_two(problem) do
    grid =
      problem
      |> make_gird()

    IO.inspect("Grid done")

    grid =
      Enum.chunk_every(problem, 2, 1, problem)
      |> Enum.reduce(grid, fn points, acc ->
        Grid.add_line(acc, points)
      end)
      |> Grid.flood_fill({grid.width - 2, grid.height - 2})

    "done"
  end

  defp make_gird(problem) do
    max_x =
      problem
      |> Enum.map(&Enum.at(&1, 0))
      |> Enum.max()

    max_y =
      problem
      |> Enum.map(&Enum.at(&1, 1))
      |> Enum.max()

    Grid.new(max_x + 1, max_y + 1)
  end
end
