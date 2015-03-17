# Wire up the visualisation
$( ->
  canvasFg = document.getElementById('layerFg')
  canvasBg = document.getElementById('layerBg')

  canvasFg.width = canvasBg.width = $('#drawArea').width()
  canvasFg.height = canvasBg.height = $('#drawArea').height()

  if canvasFg.getContext
    ctxFg = canvasFg.getContext('2d')
    ctxBg = canvasBg.getContext('2d')

    viz = new Viz(ctxFg, ctxBg, new Point(canvasFg.width, canvasFg.height))
    viz.restartCurrent()

    $('#nav li').click( ->
      chosen = parseInt($(this).attr('data-id'))
      viz.startSim(chosen)
    )
)

class Viz
  constructor: (@fg, @bg, @bounds) ->
    @currentSim = @newSim(0)

  @newKruskals: (graph, points) ->
    kruskals = new Kruskals(graph)
    components = points.length
    $('#title').text("Kruskal's MST Algorithm")
    $('#description').text("""Edges pop into view like zombies appearing through a fog, one after
      the other, till they are everywhere. EVERYWHERE!!""")
    kruskals.addCallback((e) ->
      components -= 1
      $('#info').text(if components is 1 then 'Done!!' else "#Connected Components #{ components }")
    )
    kruskals

  @newPrims: (graph, points) ->
    prims = new Prims(graph)
    connected = 1
    $('#title').text("Prim's MST Algorithm")
    $('#description').text("""Prim's MST grows like mold. Spreading at the periphery and claiming
     more of the graph over-time till is has covered all the vertices.""")
    prims.addCallback((e) ->
      connected += 1
      $('#info').text(if connected is points.length then 'Done!!' else "#Connected Vertices #{ connected }")
    )
    prims

  @algos: [@newKruskals, @newPrims]

  clearCanvas: ->
    @fg.clearRect(0, 0, @bounds.x, @bounds.y)
    @bg.clearRect(0, 0, @bounds.x, @bounds.y)

  newSim: (chosen) ->
    generator = new GraphGenerator(@bounds)
    [points, graph] = generator.generate(1000, 1)
    algo = Viz.algos[chosen](graph, points)
    new GraphSim(graph, points, algo, @fg, @bg)

  startSim: (chosen) ->
    @currentSim.stop()
    @clearCanvas()
    @currentSim = @newSim(chosen)
    @currentSim.startSim()

  restartCurrent: ->
    @currentSim.stop()
    @clearCanvas()
    @currentSim.startSim()
