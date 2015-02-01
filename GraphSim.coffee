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
    @algo = new Prims(@graph, 0)
    @algo.addCallback((e) =>
      @bg.strokeStyle = "#6fc2ef"
      @bg.beginPath()
      v = e.getEither()
      w = e.getOther(v)
      @bg.moveTo(@points[v].x, @points[v].y)
      @bg.lineTo(@points[w].x, @points[w].y)
      @bg.stroke()
      e
      )
    @startSim()

  drawPoints: ->
    @fg.fillStyle = "#fb9fb1"
    @fg.beginPath()
    for point, idx in @points
      @fg.font = "11px Georgia"
      @fg.moveTo(point.x, point.y)
      @fg.arc(point.x, point.y, 2, 0, 2 * Math.PI)
      @fg.fillText(idx, point.x, point.y)
    @fg.fill()
    return

  drawGraph: ->
    @bg.strokeStyle = "#e0e0e0"
    @bg.beginPath()
    for edge in @graph.edges
      v = edge.getEither()
      w = edge.getOther(v)
      @bg.moveTo(@points[v].x, @points[v].y)
      @bg.lineTo(@points[w].x, @points[w].y)
    @bg.stroke()

  startSim: (speed) ->
    @algo.run()

  randInt = (lo, hi) ->
    Math.floor(Math.random() * (hi - lo) + lo)