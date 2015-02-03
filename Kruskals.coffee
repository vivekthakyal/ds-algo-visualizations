class @Kruskals
  constructor: (@graph) ->
    @pq = new MinHeap(@graph.edges.length, comp)
    @uf = new UnionFind(@graph.size)
    @callbacks = []

  run: ->
    @pq.add(e) for e in @graph.edges
    result = []
    @runIteration(result)
    result

  runIteration: (result) ->
    if @pq.isEmpty()
      return
    edge = @pq.delMin()
    u = edge.getEither()
    v = edge.getOther(u)
    if !@uf.connected(u, v)
      @uf.union(u, v)
      result.push(edge)
      @fire(edge)
    setTimeout((=> @runIteration(result)), 10)

  addCallback: (callback) ->
    @callbacks.push(callback)

  fire: (edge) ->
    callback(edge) for callback in @callbacks

  comp = (e1, e2) ->
    return e1.getWeight() - e2.getWeight()
