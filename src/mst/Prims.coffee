# An implementation of Prim's MST algorithm.
class @Prims

  # Constructor
  # param: graph - the weighted graph to run MST on
  # param: s - the node to start the algorithm from. Default value is 0.
  constructor: (@graph, @s) ->
    @s = 0 if !@s?
    @pq = new IndexedHeap(@graph.size, comp)
    @callbacks = []

  # Runs the algorithm
  # returns: the edges in the MST for the graph
  run: ->
    marked = (false for x in [1..@graph.size])
    @pq.add(null, @s)
    result = []
    @runIteration(marked, result)
    result

  # A helper method to run the algo recursively.
  # This method also notifies any callbacks when
  # a new edge is added to the MST.
  runIteration: (marked, result) ->
    if @pq.isEmpty()
      return
    v = @pq.minIdx()
    edge = @pq.keyOf(v)
    if edge?
      result.push(edge)
      @fire(edge)
    @pq.delMin()
    marked[v] = true
    for e in @graph.adjacent(v)
      w = e.getOther(v)
      if !marked[w]
        if @pq.contains(w)
          if comp(@pq.keyOf(w), e) > 0
            @pq.changeKey(e, w)
        else
          @pq.add(e, w)
    setTimeout((=> @runIteration(marked, result)), 50)

  # Invokes all registered callbacks with the new edge
  # that was just added to the MST by the algo
  fire: (e) ->
    obs(e) for obs in @callbacks

  # Registers a callback which will be invoked each
  # time a new edge is added to the MST
  addCallback: (obs) ->
    @callbacks.push(obs)

  # Helper function for comparing edges
  comp = (e1, e2) ->
    return e1.getWeight() - e2.getWeight()

