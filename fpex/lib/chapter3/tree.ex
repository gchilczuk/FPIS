defmodule FP.Tree do
  alias __MODULE__

  @type t :: branch | leaf
  @typep branch :: %{left: t, right: t}
  @typep leaf :: %{value: any}

  @spec new(any) :: t
  def new(x), do: %{value: x}

  @spec size(t) :: pos_integer
  def size(%{value: _}), do: 1
  def size(%{left: l, right: r}), do: 1 + size(l) + size(r)

  @spec maximum(t) :: any
  def maximum(%{value: x}), do: x
  def maximum(%{left: l, right: r}), do: max(maximum(l), maximum(r))

  @spec depth(t) :: pos_integer
  def depth(%{value: x}), do: 1
  def depth(%{left: l, right: r}), do: 1 + max(depth(l), depth(r))

  @spec map(t, (any -> any)) :: t
  def map(%{value: x}, f), do: %{value: f.(x)}
  def map(%{left: l, right: r}, f), do: %{left: map(l, f), right: map(r, f)}
end
