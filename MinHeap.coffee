class @MinHeap
  constructor: (@capacity, @comp) ->
    @size = 0
    @pq = new Array(@capacity + 1)
    @comp = ((a, b) -> if a < b then -1 else if b < a then 1 else 0) if !@comp?

  parent = (idx) ->
    Math.floor idx / 2

  leftChild = (idx) ->
    idx * 2

  rightChild = (idx) ->
    idx * 2 + 1

  isEmpty: ->
    @size is 0

  isFull: ->
    @size is @capacity

  add: (obj) ->
    if @isFull() then throw 'Overflow: heap is full'
    @size += 1
    @pq[@size] = obj
    swim(@, @size)

  min: ->
    if @isEmpty() then throw 'NoSuchElement: heap is empty'
    @pq[1]

  delMin: ->
    min = @min()
    swap(@pq, 1, @size)
    @size -= 1
    sink(@, 1)
    return min

  swim = (obj, idx) ->
    while idx isnt 1 and obj.comp(obj.pq[idx], obj.pq[parent(idx)]) < 0
      swap(obj.pq, parent(idx), idx)
      idx = parent idx

  sink = (obj, idx) ->
    while 2 * idx <= obj.size
      min = leftChild idx
      if min < obj.size and obj.comp(obj.pq[min], obj.pq[rightChild(idx)]) > 0
        min = rightChild idx
      if obj.comp(obj.pq[min], obj.pq[idx]) > 0 then return
      swap(obj.pq, min, idx)
      idx = min

  swap = (arr, a, b) ->
    tmp = arr[a]
    arr[a] = arr[b]
    arr[b] = tmp
