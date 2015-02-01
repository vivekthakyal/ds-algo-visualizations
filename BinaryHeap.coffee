class @BinaryHeap
  constructor: (@capacity, @comp) ->
    @size = 0
    @pq = [null]
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
    @pq.push(obj)
    @size += 1
    swim(@pq, @size, @comp)

  min: ->
    if @isEmpty() then throw 'NoSuchElement: heap is empty'
    @pq[1]

  delMin: ->
    min = @min()
    swap(@pq, 1, @size)
    @size -= 1
    sink(@pq, 1, @comp, @size)
    return min

  swim = (arr, idx, comp) ->
    par = parent idx
    if comp(arr[idx], arr[par]) < 0 and par isnt 0
      swap(arr, par, idx)
      swim(arr, par, comp)

  sink = (arr, idx, comp, size) ->
    if idx is size
      return
    left = leftChild(idx)
    right = rightChild(idx)
    min = if right is size or comp(arr[right], arr[left]) < 0 then left else right
    if comp(arr[min], arr[idx]) < 0
      swap(arr, min, idx)
      sink(arr, min, comp, size)

  swap = (arr, a, b) ->
    tmp = arr[a]
    arr[a] = arr[b]
    arr[b] = tmp
