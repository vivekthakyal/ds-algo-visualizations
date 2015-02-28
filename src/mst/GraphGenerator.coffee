class @GraphGenerator
  constructor: (@bounds) ->

  generate: (numNodes, connectedness) ->
    points = (new Point(randInt(0, @bounds.x), randInt(0, @bounds.y)) for num in [1..numNodes])
    graph = new WeightedGraph(numNodes)
    for u in [0..(numNodes - 2)]
      for v in [1..(numNodes - 1)]
        if u isnt v and Math.random() < connectedness
          graph.addEdge(u, v, points[u].squaredDist(points[v]))
    [points, graph]

  randInt = (lo, hi) ->
    Math.floor(Math.random() * (hi - lo) + lo)
