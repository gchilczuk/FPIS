defmodule LinkedListTest do
  use ExUnit.Case

  alias FP.LinkedList

  test "new LinkedList" do
    assert LinkedList.new() === nil
    assert LinkedList.new(1) === %LinkedList{head: 1, tail: nil}
    assert LinkedList.new(1) === LinkedList.new([1])

    assert LinkedList.new([1, 1]) === %LinkedList{head: 1, tail: %LinkedList{head: 1, tail: nil}}

    assert LinkedList.new([4, 3, 2, 1]) === %LinkedList{
             head: 4,
             tail: %LinkedList{
               head: 3,
               tail: %LinkedList{head: 2, tail: %LinkedList{head: 1, tail: nil}}
             }
           }
  end

  test "add" do
    assert LinkedList.add(1, nil) === %LinkedList{head: 1, tail: nil}
    assert LinkedList.add(2, LinkedList.new(1)) === LinkedList.new([2, 1])
    assert LinkedList.add(5, LinkedList.new([4, 3, 2, 1])) === LinkedList.new([5, 4, 3, 2, 1])
  end

  test "tail" do
    assert LinkedList.tail(LinkedList.new(1)) === LinkedList.new()
    assert LinkedList.tail(LinkedList.new([4, 3, 2, 1])) === LinkedList.new([3, 2, 1])
  end

  test "set_head" do
    assert LinkedList.set_head(4, LinkedList.new(1)) === LinkedList.new(4)
    assert LinkedList.set_head(4, LinkedList.new([3, 2, 1])) === LinkedList.new([4, 2, 1])
  end

  test "drop" do
    linkedList = LinkedList.new([2, 1])

    assert LinkedList.drop(0, linkedList) === LinkedList.new([2, 1])
    assert LinkedList.drop(1, linkedList) === LinkedList.new(1)
    assert LinkedList.drop(4, linkedList) === LinkedList.new()
  end

  test "drop while" do
    linkedList = LinkedList.new([4, 3, 2, 1])

    assert LinkedList.dropWhile(linkedList, fn _ -> true end) === LinkedList.new()
    assert LinkedList.dropWhile(linkedList, fn x -> x > 1 end) === %LinkedList{head: 1, tail: nil}
    assert LinkedList.dropWhile(linkedList, fn x -> x > 4 end) === linkedList
    assert LinkedList.dropWhile(linkedList, fn x -> x < 4 end) === linkedList
  end

  test "init" do
    assert LinkedList.init(LinkedList.new([4, 3, 2, 1])) === LinkedList.new([4, 3, 2])
  end

  test "foldRight" do
    linkedList = LinkedList.new([4, 3, 2, 1])

    assert LinkedList.foldRight(LinkedList.new(["A", "B", "C"]), "", &(&2 <> &1)) === "CBA"
    assert LinkedList.foldRight(linkedList, 0, &:erlang.+/2) === 10
    assert LinkedList.foldRight(linkedList, 1, &:erlang.*/2) === 24

    longLinkedList = LinkedList.new(for i <- 1..10000, do: i)
    assert LinkedList.foldRight(longLinkedList, 0, &:erlang.+/2) === 50_005_000
  end

  test "foldLeft" do
    linkedList = LinkedList.new([4, 3, 2, 1])
    longLinkedList = LinkedList.new(for i <- 1..10000, do: i)

    assert LinkedList.foldLeft(LinkedList.new(["A", "B", "C"]), "", &(&2 <> &1)) === "ABC"
    assert LinkedList.foldLeft(linkedList, 0, &:erlang.+/2) === 10
    assert LinkedList.foldLeft(linkedList, 1, &:erlang.*/2) === 24
    assert LinkedList.foldLeft(longLinkedList, 0, &:erlang.+/2) === 50_005_000
  end

  test "length" do
    assert LinkedList.length(LinkedList.new()) === 0
    assert LinkedList.length(LinkedList.new(1)) === 1
    assert LinkedList.length(LinkedList.new([4, 3, 2, 1])) === 4
  end

  test "sum" do
    assert LinkedList.sum(LinkedList.new()) === 0
    assert LinkedList.sum(LinkedList.new(1)) === 1
    assert LinkedList.sum(LinkedList.new([4, 3, 2, 1])) === 10
    assert LinkedList.sum(LinkedList.new(for i <- 1..10000, do: i)) === 5000_5000
  end

  test "prod" do
    assert LinkedList.prod(LinkedList.new()) === 1
    assert LinkedList.prod(LinkedList.new(1)) === 1
    assert LinkedList.prod(LinkedList.new(2)) === 2
    assert LinkedList.prod(LinkedList.new([4, 3, 2, 1])) === 24
    assert LinkedList.prod(LinkedList.new([2, 2, 2, 2])) === 16
  end

  test "reverse" do
    assert LinkedList.reverse(LinkedList.new()) === nil
    assert LinkedList.reverse(LinkedList.new(1)) === LinkedList.new(1)
    assert LinkedList.reverse(LinkedList.new([2, 1])) === LinkedList.new([1, 2])
    assert LinkedList.reverse(LinkedList.new([5, 8, 2, 3, 1])) === LinkedList.new([1, 3, 2, 8, 5])
  end

  test "foldLeftUsingRight" do
    linkedList = LinkedList.new([4, 3, 2, 1])
    longLinkedList = LinkedList.new(for i <- 1..10000, do: i)

    assert LinkedList.foldLeftUsingRight(LinkedList.new(["A", "B", "C"]), "", &(&2 <> &1)) ===
             LinkedList.foldLeft(LinkedList.new(["A", "B", "C"]), "", &(&2 <> &1))

    assert LinkedList.foldLeftUsingRight(linkedList, 0, &:erlang.+/2) ===
             LinkedList.foldLeft(linkedList, 0, &:erlang.+/2)

    assert LinkedList.foldLeftUsingRight(linkedList, 1, &:erlang.*/2) ===
             LinkedList.foldLeft(linkedList, 1, &:erlang.*/2)

    assert LinkedList.foldLeftUsingRight(longLinkedList, 0, &:erlang.+/2) ===
             LinkedList.foldLeft(longLinkedList, 0, &:erlang.+/2)
  end

  test "foldRightUsingLeft" do
    linkedList = LinkedList.new([4, 3, 2, 1])
    longLinkedList = LinkedList.new(for i <- 1..10000, do: i)

    assert LinkedList.foldRightUsingLeft(LinkedList.new(["A", "B", "C", "D"]), "", &(&2 <> &1)) ===
             LinkedList.foldRight(LinkedList.new(["A", "B", "C", "D"]), "", &(&2 <> &1))

    assert LinkedList.foldRightUsingLeft(linkedList, 0, &:erlang.+/2) ===
             LinkedList.foldRight(linkedList, 0, &:erlang.+/2)

    assert LinkedList.foldRightUsingLeft(linkedList, 1, &:erlang.*/2) ===
             LinkedList.foldRight(linkedList, 1, &:erlang.*/2)

    assert LinkedList.foldRightUsingLeft(longLinkedList, 0, &:erlang.+/2) ===
             LinkedList.foldRight(longLinkedList, 0, &:erlang.+/2)
  end

  test "append" do
    assert LinkedList.append(LinkedList.new(), LinkedList.new()) === LinkedList.new()
    assert LinkedList.append(LinkedList.new(), LinkedList.new(1)) === LinkedList.new(1)
    assert LinkedList.append(LinkedList.new(1), LinkedList.new()) === LinkedList.new(1)
    assert LinkedList.append(LinkedList.new(1), LinkedList.new(1)) === LinkedList.new([1, 1])

    assert LinkedList.append(LinkedList.new([5, 4]), LinkedList.new([3, 2, 1])) ===
             LinkedList.new([5, 4, 3, 2, 1])
  end
end
