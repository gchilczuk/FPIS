defmodule FP.LinkedList do
  alias __MODULE__
  defstruct head: nil, tail: nil

  @typep emptyLinkedList() :: nil
  @typep notEmptyLinkedList(a) :: %LinkedList{
           head: a,
           tail: emptyLinkedList() | notEmptyLinkedList(a)
         }
  @type t(a) :: emptyLinkedList() | notEmptyLinkedList(a)

  @spec new(a) :: t(a) when a: none() | any | [] | [any]
  def new(), do: nil
  def new([]), do: nil

  def new([elem | tail]) do
    %LinkedList{head: elem, tail: LinkedList.new(tail)}
  end

  def new(elem), do: %LinkedList{head: elem}

  @spec add(a, t(a)) :: t(a) when a: any
  def add(elem, llist) do
    %LinkedList{head: elem, tail: llist}
  end

  @spec tail(notEmptyLinkedList(a)) :: t(a) when a: any
  def tail(%LinkedList{tail: t}), do: t

  @spec set_head(a, notEmptyLinkedList(a)) :: notEmptyLinkedList(a) when a: any
  def set_head(new_head, %LinkedList{tail: t}), do: %LinkedList{head: new_head, tail: t}

  @spec drop(non_neg_integer(), t(a)) :: t(a) when a: any
  def drop(n, %LinkedList{tail: t} = llist) do
    case {n, t} do
      {0, _} -> llist
      {_, nil} -> nil
      _ -> drop(n - 1, t)
    end
  end

  @spec dropWhile(notEmptyLinkedList(a), (a -> boolean())) :: t(a) when a: any
  def dropWhile(%LinkedList{head: h, tail: t} = llist, predicate) do
    case {predicate.(h), t} do
      {true, nil} -> nil
      {true, _} -> dropWhile(t, predicate)
      _ -> llist
    end
  end

  @spec init(notEmptyLinkedList(a)) :: notEmptyLinkedList(a) when a: any
  def init(%LinkedList{head: h, tail: t}) do
    case t do
      nil -> nil
      _ -> %LinkedList{head: h, tail: init(t)}
    end
  end

  @spec foldRight(t(a), b, (a, b -> b)) :: b when a: any, b: any
  def foldRight(llist, acc, f) do
    case llist do
      nil -> acc
      %LinkedList{head: h, tail: t} -> f.(h, foldRight(t, acc, f))
    end
  end

  @spec foldLeft(t(a), b, (a, b -> b)) :: b when a: any, b: any
  def foldLeft(llist, acc, f) do
    case llist do
      nil -> acc
      %LinkedList{head: h, tail: t} -> foldLeft(t, f.(h, acc), f)
    end
  end

  @spec length(t(any)) :: non_neg_integer()
  def length(llist) do
    foldLeft(llist, 0, fn _, acc -> acc + 1 end)
    foldRight(llist, 0, fn _, acc -> acc + 1 end)
  end

  @spec sum(t(any)) :: integer()
  def sum(llist) do
    foldLeft(llist, 0, &:erlang.+/2)
  end

  @spec prod(t(any)) :: integer()
  def prod(llist) do
    foldLeft(llist, 1, &:erlang.*/2)
  end

  @spec reverse(t(a)) :: t(a) when a: any
  def reverse(llist) do
    foldLeft(llist, nil, fn elem, acc -> LinkedList.add(elem, acc) end)
  end

  @spec foldLeftUsingRight(t(a), b, (a, b -> b)) :: b when a: any, b: any
  def foldLeftUsingRight(llist, acc, f) do
    # foldRight(LinkedList.reverse(llist), acc, f)
    foldRight(llist, & &1, fn elem, acc -> fn real_acc -> f.(acc.(elem), real_acc) end end).(acc)
  end

  @spec foldRightUsingLeft(t(a), b, (a, b -> b)) :: b when a: any, b: any
  def foldRightUsingLeft(llist, acc, f) do
    # WRONG?
    foldLeft(llist, & &1, fn elem, acc -> fn real_acc -> f.(acc.(elem), real_acc) end end).(acc)
  end

  @spec append(t(a), t(a)) :: t(a) when a: any
  def append(first, second) do
    case first do
      nil -> second
      %LinkedList{tail: t} -> %{first | tail: append(t, second)}
    end

    foldRight(first, second, fn elem, acc -> %LinkedList{head: elem, tail: acc} end)
    # foldLeft(first, second, ) # 
  end

  @spec flatten(t(t(a))) :: t(a) when a: any
  def flatten(llist2d) do
  end
end
