defmodule Aoc2025.Util.Grid do
  defstruct [:grid, :width, :height]

  @behaviour Access

  def new(input, value_transformer \\ & &1) do
    lines = String.split(input, ~r/\R/, trim: true)
    height = length(lines)
    width = if height > 0, do: String.length(hd(lines)), else: 0

    grid =
      for {line, y} <- Enum.with_index(lines),
          {char, x} <- Enum.with_index(String.graphemes(line)),
          into: %{} do
        {{x, y}, value_transformer.(char)}
      end

    %__MODULE__{grid: grid, width: width, height: height}
  end

  def get_value(%__MODULE__{grid: grid}, key, default \\ nil) do
    Map.get(grid, key, default)
  end

  def set_value(%__MODULE__{grid: grid} = m, key, new_value) do
    %{m | grid: Map.put(grid, key, new_value)}
  end

  def map(%__MODULE__{grid: grid} = m, transformer) do
    new_grid = Map.new(grid, fn {pos, val} -> {pos, transformer.(pos, val)} end)
    %{m | grid: new_grid}
  end

  @impl Access
  def fetch(%__MODULE__{grid: grid}, key), do: Map.fetch(grid, key)

  @impl Access
  def get_and_update(%__MODULE__{grid: grid} = m, key, function) do
    {res, new_grid} = Map.get_and_update(grid, key, function)
    {res, %{m | grid: new_grid}}
  end

  @impl Access
  def pop(%__MODULE__{grid: grid} = m, key) do
    {res, new_grid} = Map.pop(grid, key)
    {res, %{m | grid: new_grid}}
  end
end

defimpl Inspect, for: Aoc2025.Util.Grid do
  def inspect(grid, _opts) do
    import Inspect.Algebra

    rows =
      for y <- 0..(grid.height - 1) do
        line = for x <- 0..(grid.width - 1), do: to_string(grid[{x, y}])
        Enum.join(line)
      end

    concat(["#Grid<#{grid.width}x#{grid.height}>\n", Enum.join(rows, "\n")])
  end
end
