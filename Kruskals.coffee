# An implementation of Kruskal's MST algorithm.
class @Kruskals

  # Constructor
  # param: graph - the weighted graph to run MST on
  # param: clusters - the number of clusters to stop the execution
  #                   of the algorithm at. Default value is 1.
  constructor: (@graph, @clusters) ->
    @pq = new MinHeap(@graph.edges.length, comp)
    @uf = new UnionFind(@graph.size)
    @clusters = 1 if !@clusters?
    @callbacks = []

  # Runs the algorithm
  # returns: the edges in the MST for the graph
  run: ->
    @pq.add(e) for e in @graph.edges
    result = []
    @runIteration(result)
    result

  # A helper method to run the algo recursively.
  # This method also notifies any callbacks when
  # a new edge is added to the MST.
  runIteration: (result) ->
    if @pq.isEmpty() or @uf.count is @clusters
      return
    edge = @pq.delMin()
    u = edge.getEither()
    v = edge.getOther(u)
    if !@uf.connected(u, v)
      @uf.union(u, v)
      result.push(edge)
      @fire(edge)
      setTimeout((=> @runIteration(result)), 20)
    else
      @runIteration(result)

  # Registers a callback which will be invoked each
  # time a new edge is added to the MST
  addCallback: (callback) ->
    @callbacks.push(callback)

  # Invokes all registered callbacks with the new edge
  # that was just added to the MST by the algo
  fire: (edge) ->
    callback(edge) for callback in @callbacks

  # Helper function for comparing edges
  comp = (e1, e2) ->
    return e1.getWeight() - e2.getWeight()
