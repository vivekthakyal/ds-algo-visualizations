# A class representing a 2-D point
class @Point
  constructor: (@x, @y) ->

  square = (x) ->
    x * x

  squaredDist: (other) ->
    square(@x - other.x) + square(@y - other.y)

class @GraphSim
  # Constructor
  #
  # param: bounds - a point object representing the width and height of the canvas
  # param: numPoints - number of vertices in the graph
  # param: connectedness - a float in the range [0 - 1] that represents the connectedness of the
  #                        graph. No two vertices will be connected if it is 0 and every node will
  #                        be connected to every other node if connectedness is 1. Any value between
  #                        0 and 1 will result in varying degree of connectedness.
  constructor: (@bounds, @numPoints, @connectedness, @fg, @bg) ->
    @points = (new Point(randInt(0, @bounds.x), randInt(0, @bounds.y)) for num in [1..@numPoints])
    @graph = new WeightedGraph(@numPoints)
    for v in [0..(@numPoints - 2)]
      for w in [v..(@numPoints - 1)]
        if v isnt w and Math.random() < @connectedness
          @graph.addEdge(v, w, @points[v].squaredDist(@points[w]))

    # @drawGraph()
    @drawPoints()
    @algo = new Kruskals(@graph, 20)
    @algo.addCallback((e) =>
      @bg.strokeStyle = "#6fc2ef"
      @bg.beginPath()
      v = e.getEither()
      w = e.getOther(v)
      @bg.moveTo(@points[v].x, @points[v].y)
      @bg.lineTo(@points[w].x, @points[w].y)
      @bg.stroke()
      )
    @startSim()

  drawPoints: ->
    @fg.fillStyle = "#fb9fb1"
    @fg.beginPath()
    for point, idx in @points
      @fg.moveTo(point.x, point.y)
      @fg.arc(point.x, point.y, 2, 0, 2 * Math.PI)
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