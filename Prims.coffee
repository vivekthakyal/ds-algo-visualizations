class @Prims
  constructor: (@graph, @s) ->
    @s = 0 if !@s?
    @pq = new IndexedHeap(@graph.size, comp)
    @callbacks = []

  run: ->
    marked = (false for x in [1..@graph.size])
    @pq.add(null, @s)
    result = []
    while(!@pq.isEmpty())
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
    result

  comp = (e1, e2) ->
    return e1.getWeight() - e2.getWeight()

  fire: (e) ->
    obs(e) for obs in @callbacks

  addCallback: (obs) ->
    @callbacks.push(obs)
