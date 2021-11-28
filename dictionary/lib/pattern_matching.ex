defmodule T do
  def swap({ a, b }), do: { b, a }

  def equal(a, a), do: true
  def equal(_, _), do: false

  def len([]), do: 0
  def len([_h|t]), do: 1 + len(t)

  def sum([]), do: 0
  def sum([h|t]), do: h + sum(t)

  def square([]), do: []
  def square([h|t]), do: [ h*h | square(t) ]

  def double([]), do: []
  def double([h|t]), do: [ 2*h | double(t) ]  

  def map([], _func), do: []
  def map([h|t], func), do: [ func.(h) | map(t, func) ]

  def sum_pairs([]), do: []
  def sum_pairs([ h1, h2 | t]), do: [h1 + h2 | sum_pairs(t)]

  def even_length([]), do: true
  def even_length([ _h | []]), do: false
  def even_length([_h1, _h2 | t]), do: even_length(t)

end

