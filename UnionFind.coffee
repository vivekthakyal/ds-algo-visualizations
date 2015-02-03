class @UnionFind
  constructor: (capacity) ->
    @id = (x for x in [0..capacity])
    @rank = (0 for x in [0..capacity])
    @count = capacity

  find: (p) ->
    if p < 0 or p >= @id.length
      throw "IndexOutOfBounds: #{ p }"
    while p isnt @id[p]
      @id[p] = @id[@id[p]]
      p = @id[p]
    p

  connected: (p, q) ->
    @find(p) is @find(q)

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
