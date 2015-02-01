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
    return @keys[@pq[@qp[idx]]]

  changeKey: (key, idx) ->
    if @isEmpty() or !@contains(idx) then throw 'NoSuchElement:'
    @keys[@pq[@qp[idx]]] = key
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
    while idx < @size and (greater(obj, idx, leftChild(idx)) or greater(obj, idx, rightChild(idx)))
      min = if greater(obj, leftChild(idx), rightChild(idx)) then rightChild(idx) else leftChild(idx)
      exch(obj, idx, min)
      idx = min
    return

  swim = (obj, idx) ->
    while idx > 1 and greater(obj, parent(idx), idx)
      exch(obj, parent(idx), idx)
      idx = parent(idx)
    return
