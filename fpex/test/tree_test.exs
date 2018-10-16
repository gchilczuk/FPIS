defmodule TreeTest do
  use ExUnit.Case

  alias FP.Tree

  test "size" do
    assert Tree.size(%{value: 5}) === 1
    assert Tree.size(%{left: %{value: 1}, right: %{value: 5}}) === 3
    assert Tree.size(%{left: %{value: 1}, right: %{left: %{value: 3}, right: %{value: 5}}}) === 5
  end

  test "maximum" do
    assert Tree.maximum(%{value: 5}) === 5
    assert Tree.maximum(%{left: %{value: 1}, right: %{value: 5}}) === 5

    assert Tree.maximum(%{left: %{value: 1}, right: %{left: %{value: 3}, right: %{value: 5}}}) ===
             5

    assert Tree.maximum(%{left: %{value: 1}, right: %{left: %{value: 5}, right: %{value: 5}}}) ===
             5

    assert Tree.maximum(%{left: %{value: 1}, right: %{left: %{value: 5}, right: %{value: 2}}}) ===
             5

    assert Tree.maximum(%{left: %{value: 5}, right: %{left: %{value: 1}, right: %{value: 2}}}) ===
             5
  end

  test "depth" do
    assert Tree.depth(%{value: 5}) === 1
    assert Tree.depth(%{left: %{value: 1}, right: %{value: 5}}) === 2

    assert Tree.depth(%{left: %{value: 1}, right: %{left: %{value: 3}, right: %{value: 5}}}) === 3

    assert Tree.depth(%{left: %{value: 1}, right: %{left: %{value: 5}, right: %{value: 5}}}) === 3

    assert Tree.depth(%{
             left: %{value: 1},
             right: %{left: %{left: %{value: 5}, right: %{value: 3}}, right: %{value: 2}}
           }) === 4
  end

  test "map" do
    f = &(&1 + 1)
    assert Tree.map(%{value: 5}, f) === %{value: 6}

    assert Tree.map(%{left: %{value: 1}, right: %{value: 5}}, f) === %{
             left: %{value: 2},
             right: %{value: 6}
           }

    Tree.map(
      %{
        left: %{value: 1},
        right: %{left: %{left: %{value: 5}, right: %{value: 3}}, right: %{value: 2}}
      },
      f
    ) === %{
      left: %{value: 2},
      right: %{left: %{left: %{value: 6}, right: %{value: 4}}, right: %{value: 3}}
    }
  end
end
