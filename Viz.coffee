$( ->
  canvasFg = document.getElementById('layerFg')
  canvasBg = document.getElementById('layerBg')

  canvasFg.width = canvasBg.width = $('#drawArea').width()
  canvasFg.height = canvasBg.height = $('#drawArea').height()
  if canvasFg.getContext
    ctxFg = canvasFg.getContext('2d')
    ctxBg = canvasBg.getContext('2d')

    sim = new MSTSim(new Point(canvasFg.width, canvasFg.height), 500, 1000, ctxFg, ctxBg)
)