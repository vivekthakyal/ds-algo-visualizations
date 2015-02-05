# A class for a weighted edge
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

# A class for a an undirected graph that has
#  weighted edges
class @WeightedGraph

  # Constructor
  # param: size - the number of vertices in the graph
  constructor: (@size) ->
    @adj = new Array(@size)
    @edges = []

  # Adds an edge to the graph between two nodes v & w
  # and weight 'weight'
  addEdge: (v, w, weight) ->
    edge = new Edge(v, w, weight)
    @edges.push(edge)
    @adj[v] = [] if !@adj[v]?
    @adj[v].push(edge)
    @adj[w] = [] if !@adj[w]?
    @adj[w].push(edge)

  # Returns all the edges incident on the passed vertex
  adjacent: (v) ->
    @adj[v] or []
