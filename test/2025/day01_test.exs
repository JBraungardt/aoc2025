defmodule Aoc2025.Solutions.Y25.Day01Test do
  alias AoC.Input, warn: false
  alias Aoc2025.Solutions.Y25.Day01, as: Solution, warn: false
  use ExUnit.Case, async: true

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem])
  end

  test "part one example" do
    input = ~S"""
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
    """

    assert 3 == solve(input, :part_one)
  end

  test "part two example" do
    input = ~S"""
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
    """

    assert 6 == solve(input, :part_two)
  end
end
