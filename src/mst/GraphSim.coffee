# A class representing a 2-D point
class @Point
  constructor: (@x, @y) ->

  square = (x) ->
    x * x

  squaredDist: (other) ->
    square(@x - other.x) + square(@y - other.y)

# Simulation harness for graph algorithms
class @GraphSim
  # Constructor
  #
  # param: bounds - a point object representing the width and height of the canvas
  # param: numPoints - number of vertices in the graph
  # param: connectedness - a float in the range [0 - 1] that represents the connectedness of the
  #                        graph. No two vertices will be connected if it is 0 and every node will
  #                        be connected to every other node if connectedness is 1. Any value between
  #                        0 and 1 will result in varying degree of connectedness.
  # constructor: (@bounds, @numPoints, @connectedness, @fg, @bg) ->
  constructor: (@graph, @points, @algo, @fg, @bg) ->
    @algo.addCallback((e) =>
      @bg.strokeStyle = "#66cccc"
      @bg.beginPath()
      v = e.getEither()
      w = e.getOther(v)
      @bg.moveTo(@points[v].x, @points[v].y)
      @bg.lineTo(@points[w].x, @points[w].y)
      @bg.stroke()
      @components -= 1
      )

  drawPoints: ->
    @fg.fillStyle = "#f2777a"
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
    # @drawGraph()
    @drawPoints()
    @algo.run()
