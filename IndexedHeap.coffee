class @IndexedHeap
  constructor: (@capacity, @comp) ->
    @size = 0
    @pq = (-1 for x in [1..(@capacity + 1)])
    @qp = (-1 for x in [1..(@capacity + 1)])
    @keys = (null for x in [1..(@capacity + 1)])
    @comp = ((a, b) -> if a < b then -1 else if b < a then 1 else 0) if !@comp?

  parent = (idx) ->
    Math.floor(idx / 2)

  leftChild = (idx) ->
    idx * 2

  rightChild = (idx) ->
    idx * 2 + 1

  isFull: ->
    @size is @capacity

  isEmpty: ->
    @size is 0

  add: (key, idx) ->
    # console.log("add - edge: #{ key }, idx: #{ idx }")
    if @isFull() then throw 'Overflow: heap is full'
    @size += 1
    @pq[@size] = idx
    @qp[idx] = @size
    @keys[idx] = key
    swim(@, @size)

  contains: (idx) ->
    return @qp[idx] isnt -1

  keyOf: (idx) ->
    if @isEmpty() or !@contains(idx) then throw 'NoSuchElement:'
    return @keys[idx]

  changeKey: (key, idx) ->
    # console.log("changeKey - edge: #{ key }, idx: #{ idx }")
    if @isEmpty() or !@contains(idx) then throw 'NoSuchElement:'
    @keys[idx] = key
    swim(@, @qp[idx])
    sink(@, @qp[idx])

  minIdx: ->
    if @isEmpty() then throw 'NoSuchElement: heap is empty'
    @pq[1]

  minKey: ->
    if @isEmpty() then throw 'NoSuchElement: heap is empty'
    @keys[@pq[1]]

  delMin: ->
    min = @pq[1]
    # console.log("delMin - minKey: #{ @minKey() }, minIdx: #{ @minIdx() }")
    exch(@, 1, @size)
    @size -= 1
    sink(@, 1)
    @qp[min] = -1
    @keys[@pq[@size + 1]] = null
    @pq[@size + 1] = -1
    min

  exch = (obj, a, b) ->
    temp = obj.pq[a]
    obj.pq[a] = obj.pq[b]
    obj.pq[b] = temp
    obj.qp[obj.pq[a]] = a
    obj.qp[obj.pq[b]] = b

  greater = (obj, i, j) ->
    obj.comp(obj.keys[obj.pq[i]], obj.keys[obj.pq[j]]) > 0

  sink = (obj, idx) ->
    while 2 * idx <= obj.size
      min = leftChild(idx)
      if min < obj.size and greater(obj, min, rightChild(idx))
        min = rightChild(idx)
      if !greater(obj, idx, min)
        break
      exch(obj, idx, min)
      idx = min
    return

  swim = (obj, idx) ->
    while idx > 1 and greater(obj, parent(idx), idx)
      exch(obj, parent(idx), idx)
      idx = parent(idx)
    return
