# An implementaion of an indexed priority queue that allows changing the value
# of the key of an element in log n time in addition to add and delMin operations.
class @IndexedHeap

  # Constructor
  # param: capacity - the max number of elements this heap can hold
  # param: comp - a function to compare the elements to be added in the heap.
  #               Default comp function assumes the elements to be numeric.
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

  # Adds a new element to the heap
  # param: key - the key of the element to add
  # param: idx - index/identifier of the element to add
  add: (key, idx) ->
    # console.log("add - edge: #{ key }, idx: #{ idx }")
    if @isFull() then throw 'Overflow: heap is full'
    @size += 1
    @pq[@size] = idx
    @qp[idx] = @size
    @keys[idx] = key
    swim(@, @size)

  # Returns true if the an element with the passed index/identifier
  # is present in the heap, false otherwise
  contains: (idx) ->
    return @qp[idx] isnt -1

  # Returns the key associated with the element having the passed
  # index/identifier
  keyOf: (idx) ->
    if @isEmpty() or !@contains(idx) then throw 'NoSuchElement:'
    return @keys[idx]

  # Change the key associated with the element having the passed
  # index/identifier
  # param: key - the new key
  # param: idx index/identifier of the element associated with the key
  changeKey: (key, idx) ->
    # console.log("changeKey - edge: #{ key }, idx: #{ idx }")
    if @isEmpty() or !@contains(idx) then throw 'NoSuchElement:'
    @keys[idx] = key
    swim(@, @qp[idx])
    sink(@, @qp[idx])

  # Returns the index/identifier of the element associated with the
  # smallest key in the heap
  minIdx: ->
    if @isEmpty() then throw 'NoSuchElement: heap is empty'
    @pq[1]

  # Returns the smallest key in the heap
  minKey: ->
    if @isEmpty() then throw 'NoSuchElement: heap is empty'
    @keys[@pq[1]]

  # Deletes the entry corresponding to the element that is associated with the
  # smallest key in the heap
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
