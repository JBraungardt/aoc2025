defmodule Day08.Box do
  @enforce_keys [:position]
  defstruct position: [], circuit: nil, direct: MapSet.new()

  def new(position) when is_list(position) do
    %__MODULE__{position: position, circuit: make_ref()}
  end

  def distance(%__MODULE__{} = lhs, %__MODULE__{} = rhs) do
    [x1, y1, z1] = lhs.position
    [x2, y2, z2] = rhs.position

    :math.sqrt(:math.pow(x1 - x2, 2) + :math.pow(y1 - y2, 2) + :math.pow(z1 - z2, 2))
  end

  def is_directly_connected?(%__MODULE__{direct: connected}, %__MODULE__{position: pos}) do
    MapSet.member?(connected, pos)
  end

  def add_direct_connection(%__MODULE__{} = box1, %__MODULE__{} = box2) do
    MapSet.put(box1.direct, box2.position)
  end
end

defimpl String.Chars, for: Day08.Box do
  def to_string(box) do
    [x, y, z] = box.position
    "{x: #{x}, y: #{y}, z: #{z}}"
  end
end

defmodule Aoc2025.Solutions.Y25.Day08 do
  alias Day08.Box
  alias AoC.Input

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

  def part_one(problem) do
    boxes = Enum.map(problem, &Box.new/1)

    Enum.reduce(1..1000, boxes, fn _, acc -> create_circuit(acc) end)
    |> Enum.group_by(& &1.circuit)
    |> Enum.map(fn {_ref, circuit} -> length(circuit) end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  defp create_circuit(boxes) do
    {{%Box{circuit: c1} = b1, %Box{circuit: c2} = b2}, _} = find_shortest(boxes)

    boxes
    |> update_in([Access.filter(&(&1.position == b1.position))], fn %Box{} = box ->
      %{box | circuit: c2}
    end)
    |> update_in([Access.filter(&(&1.circuit == c1))], fn %Box{} = box ->
      %{box | circuit: c2}
    end)
    |> update_in([Access.filter(&(&1.position == b1.position))], fn %Box{} = box ->
      %{box | direct: Box.add_direct_connection(box, b2)}
    end)
    |> update_in([Access.filter(&(&1.position == b2.position))], fn %Box{} = box ->
      %{box | direct: Box.add_direct_connection(box, b1)}
    end)
  end

  defp find_shortest(list) do
    do_find_shortest(list, {{}, nil})
  end

  defp do_find_shortest([], result), do: result

  defp do_find_shortest([head | tail], result) do
    result =
      Enum.reduce(tail, result, fn other, {_, shortest_distance} = result ->
        distance = Box.distance(head, other)

        if distance < shortest_distance and not Box.is_directly_connected?(head, other) do
          {{head, other}, distance}
        else
          result
        end
      end)

    do_find_shortest(tail, result)
  end

  def part_two(problem) do
    boxes = Enum.map(problem, &Box.new/1)

    {%Box{position: [x1, _, _]}, %Box{position: [x2, _, _]}} =
      Enum.reduce_while(boxes, boxes, fn _, acc ->
        create_circuit2(acc)
      end)

    x1 * x2
  end

  defp create_circuit2(boxes) do
    {{%Box{circuit: c1} = b1, %Box{circuit: c2} = b2}, _} = find_shortest2(boxes)

    boxes =
      boxes
      |> update_in([Access.filter(&(&1.position == b1.position))], fn %Box{} = box ->
        %{box | circuit: c2}
      end)
      |> update_in([Access.filter(&(&1.circuit == c1))], fn %Box{} = box ->
        %{box | circuit: c2}
      end)

    case Enum.uniq_by(boxes, & &1.circuit) |> Enum.count() do
      1 -> {:halt, {b1, b2}}
      _ -> {:cont, boxes}
    end
  end

  defp find_shortest2(list) do
    do_find_shortest2(list, {{}, nil})
  end

  defp do_find_shortest2([], result), do: result

  defp do_find_shortest2([head | tail], result) do
    result =
      Enum.reduce(tail, result, fn other, {_, shortest_distance} = result ->
        distance = Box.distance(head, other)

        if distance < shortest_distance and head.circuit != other.circuit do
          {{head, other}, distance}
        else
          result
        end
      end)

    do_find_shortest2(tail, result)
  end
end
