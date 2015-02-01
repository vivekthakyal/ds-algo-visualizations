class @Prims
  constructor: (@graph, @s) ->
    @s = 0 if !@s?
    @pq = new BinaryHeap(@graph.size, (e1, e2) -> e1.weight - e2.weight)

  run: ->
    marked = (false for x in [1..@graph.size])
