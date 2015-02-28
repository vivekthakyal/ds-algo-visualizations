# Wire up the visualisation
$( ->
  canvasFg = document.getElementById('layerFg')
  canvasBg = document.getElementById('layerBg')

  canvasFg.width = canvasBg.width = $('#drawArea').width()
  canvasFg.height = canvasBg.height = $('#drawArea').height()
  if canvasFg.getContext
    ctxFg = canvasFg.getContext('2d')
    ctxBg = canvasBg.getContext('2d')

    sim = new GraphSim(new Point(canvasFg.width, canvasFg.height), 1000, 1, ctxFg, ctxBg)
)