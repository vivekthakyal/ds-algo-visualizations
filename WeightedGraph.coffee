class @Edge
  constructor: (@v, @w, @weight) ->

  getEither: ->
    return @v

  getOther: (v) ->
    if v is @v then @w else @v

  getWeight: ->
    @weight

  toString: ->
    "#{ @v } - #{ @w } [#{ @weight }]"

class @WeightedGraph

  constructor: (@size) ->
    @adj = new Array(@size)
    @edges = []

  addEdge: (v, w, weight) ->
    edge = new Edge(v, w, weight)
    @edges.push(edge)
    @adj[v] = [] if !@adj[v]?
    @adj[v].push(edge)
    @adj[w] = [] if !@adj[w]?
    @adj[w].push(edge)

  adjacent: (v) ->
    @adj[v] or []
