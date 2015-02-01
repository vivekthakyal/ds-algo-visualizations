class @Point
  constructor: (@x, @y) ->

  square = (x) ->
    x * x

  squaredDist: (other) ->
    square(@x - other.x) + square(@y - other.y)

class @GraphSim
  constructor: (@bounds, @numPoints, @numEdges, @fg, @bg) ->
    @points = (new Point(randInt(0, @bounds.x), randInt(0, @bounds.y)) for num in [1..@numPoints])
    @graph = new WeightedGraph(@numPoints)
    for i in [1..@numEdges]
      v = randInt(0, @numPoints)
      w = randInt(0, @numPoints)
      @graph.addEdge(v, w, @points[v].squaredDist(@points[w]))
    @drawGraph()
    @drawPoints()

  drawPoints: ->
    @bg.fillStyle = "#0e2f44"
    @bg.beginPath()
    for point in @points
      @bg.moveTo(point.x, point.y)
      @bg.arc(point.x, point.y, 2, 0, 2 * Math.PI)
    @bg.fill()
    return

  drawGraph: ->
    @bg.strokeStyle = "#cceeff"
    @bg.beginPath()
    for edge in @graph.edges
      v = edge.getEither()
      w = edge.getOther(v)
      @bg.moveTo(@points[v].x, @points[v].y)
      @bg.lineTo(@points[w].x, @points[w].y)
    @bg.stroke()

  startSim: (algo, speed) ->

  randInt = (lo, hi) ->
    Math.floor(Math.random() * (hi - lo) + lo)