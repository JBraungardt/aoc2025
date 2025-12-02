defmodule Aoc2025.Solutions.Y25.Day01 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [direction, distance_str] = Regex.run(~r/^(\w)(\d+)/, line, capture: :all_but_first)

    {direction, String.to_integer(distance_str)}
  end

  def part_one(problem) do
    to_turn1(50, problem, 0)
  end

  def to_turn1(_pos, [], no_of_zeros), do: no_of_zeros

  def to_turn1(pos, [turn | rest], no_of_zeros) do
    {next_pos, no_of_zeros} = next_pos1(pos, turn, no_of_zeros)

    to_turn1(next_pos, rest, no_of_zeros)
  end

  defp next_pos1(pos, {"L", distance}, no_of_zeros) do
    next_pos = pos - distance

    no_of_zeros =
      case next_pos do
        0 -> no_of_zeros + 1
        _ -> no_of_zeros
      end

    next_pos = maybe_adjust_overflow1(next_pos)

    {next_pos, no_of_zeros}
  end

  defp next_pos1(pos, {"R", distance}, no_of_zeros) do
    next_pos = pos + distance

    next_pos = maybe_adjust_overflow1(next_pos)

    no_of_zeros =
      case next_pos do
        0 -> no_of_zeros + 1
        _ -> no_of_zeros
      end

    {next_pos, no_of_zeros}
  end

  defp maybe_adjust_overflow1(pos) when pos >= 0 and pos < 100, do: pos
  defp maybe_adjust_overflow1(pos) when pos < 0, do: maybe_adjust_overflow1(pos + 100)
  defp maybe_adjust_overflow1(pos) when pos >= 100, do: maybe_adjust_overflow1(pos - 100)

  def part_two(problem) do
    to_turn2(50, problem, 0)
  end

  def to_turn2(_pos, [], no_of_zeros), do: no_of_zeros

  def to_turn2(pos, [turn | rest], no_of_zeros) do
    {next_pos, no_of_zeros} = next_pos2(pos, turn, no_of_zeros)

    to_turn2(next_pos, rest, no_of_zeros)
  end

  defp next_pos2(pos, {"L", distance}, no_of_zeros) do
    next_pos = pos - rem(distance, 100)

    no_of_zeros = no_of_zeros + div(distance, 100)

    no_of_zeros =
      cond do
        pos == 0 -> no_of_zeros
        next_pos <= 0 -> no_of_zeros + 1
        true -> no_of_zeros
      end

    next_pos = Integer.mod(next_pos, 100)
    {next_pos, no_of_zeros}
  end

  defp next_pos2(pos, {"R", distance}, no_of_zeros) do
    next_pos = pos + rem(distance, 100)

    no_of_zeros = no_of_zeros + div(distance, 100)

    no_of_zeros =
      cond do
        pos == 0 -> no_of_zeros
        next_pos >= 100 -> no_of_zeros + 1
        true -> no_of_zeros
      end

    next_pos = Integer.mod(next_pos, 100)
    {next_pos, no_of_zeros}
  end
end
