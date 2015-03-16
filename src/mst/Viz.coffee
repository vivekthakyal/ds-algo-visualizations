# Wire up the visualisation
$( ->
  canvasFg = document.getElementById('layerFg')
  canvasBg = document.getElementById('layerBg')

  canvasFg.width = canvasBg.width = $('#drawArea').width()
  canvasFg.height = canvasBg.height = $('#drawArea').height()

  clearCanvas = () ->
    ctxFg.clearRect(0, 0, canvasFg.width, canvasFg.height)
    ctxBg.clearRect(0, 0, canvasFg.width, canvasFg.height)

  restartSim = (sim) ->
    clearCanvas()
    sim.startSim()

  if canvasFg.getContext
    ctxFg = canvasFg.getContext('2d')
    ctxBg = canvasBg.getContext('2d')

    generator = new GraphGenerator(new Point(canvasFg.width, canvasFg.height))
    [points, graph] = generator.generate(1000, 1)
    kruskals = newKruskals(graph, points)
    # prims = newPrims(graph, points)

    sim = new GraphSim(graph, points, kruskals, ctxFg, ctxBg)
    restartSim(sim)
)

newPrims = (graph, points) ->
  prims = new Prims(graph)
  connected = 1
  prims.addCallback((e) ->
    connected += 1
    $('#info').text(if connected is points.length then 'Done!!' else "#Connected Vertices #{ connected }")
  )
  prims

newKruskals = (graph, points) ->
  kruskals = new Kruskals(graph)
  components = points.length
  kruskals.addCallback((e) ->
    components -= 1
    $('#info').text(if components is 1 then 'Done!!' else "#Connected Components #{ components }")
  )
  kruskals