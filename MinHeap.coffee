# A minimum priority queue implementation with log n run time
# bound for add and delMin operations
class @MinHeap

  # Constructor
  # param: capacity - the max number of elements this heap can hold
  # param: comp - a function to compare the elements to be added in the heap.
  #               Default comp function assumes the elements to be numeric.
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

  # Adds a new element to the heap. Run time complexity of this operation
  # is log n, where n is the numner of elements in the heap
  # param: obj - the element to add
  add: (obj) ->
    if @isFull() then throw 'Overflow: heap is full'
    @size += 1
    @pq[@size] = obj
    swim(@, @size)

  # Return the minimum element in the heap. This operation takes constant time.
  min: ->
    if @isEmpty() then throw 'NoSuchElement: heap is empty'
    @pq[1]

  # Removes the smallest element from the heap. This operation takes time propotional
  # to log n where n is the number of elements in the heap
  delMin: ->
    min = @min()
    swap(@pq, 1, @size)
    @size -= 1
    sink(@, 1)
    return min

  # A helper function to move an element up the heap as long as it is smaller than
  # its parent element in the tree.
  swim = (obj, idx) ->
    while idx isnt 1 and obj.comp(obj.pq[idx], obj.pq[parent(idx)]) < 0
      swap(obj.pq, parent(idx), idx)
      idx = parent idx

  # A helper function to move an element down the heap as long as it is greater than
  # any of its children in the tree.
  sink = (obj, idx) ->
    while 2 * idx <= obj.size
      min = leftChild idx
      if min < obj.size and obj.comp(obj.pq[min], obj.pq[rightChild(idx)]) > 0
        min = rightChild idx
      if obj.comp(obj.pq[min], obj.pq[idx]) > 0 then return
      swap(obj.pq, min, idx)
      idx = min

  # A helper function to swap elements in the heap
  swap = (arr, a, b) ->
    tmp = arr[a]
    arr[a] = arr[b]
    arr[b] = tmp
