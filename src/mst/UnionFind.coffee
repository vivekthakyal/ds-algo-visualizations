# An implementation of UnionFind that uses rank and path compression
class @UnionFind
  # Constructor
  # param: capacity - the max number of elements
  constructor: (capacity) ->
    @id = (x for x in [0..capacity])
    @rank = (0 for x in [0..capacity])
    @count = capacity

  # Returns the identifier of the connected component
  # the passed element is part of
  # param: p - element to find the connected component of
  find: (p) ->
    if p < 0 or p >= @id.length
      throw "IndexOutOfBounds: #{ p }"
    while p isnt @id[p]
      @id[p] = @id[@id[p]]
      p = @id[p]
    p

  # Returns true if the two elements are part of the same
  # connected componenet
  connected: (p, q) ->
    @find(p) is @find(q)

  # Union the connected components of the passed elements
  union: (p, q) ->
    a = @find(p)
    b = @find(q)
    if a is b then return

    if @rank[a] > @rank[b] then @id[b] = a
    else if @rank[a] < @rank[b] then @id[a] = b
    else
      @id[b] = a
      @rank[a] += 1
    @count--
