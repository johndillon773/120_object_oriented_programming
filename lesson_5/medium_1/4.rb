# Circular Queue

class CircularQueue
  def initialize(n)
    @arr = Array.new(n)
  end

  def enqueue(element)
    @arr = @arr.rotate(1)
    @arr[-1] = element
  end

  def dequeue
    oldest = @arr[oldest_element_index]
    @arr[oldest_element_index] = nil
    oldest
  end

private

  def oldest_element_index
    @arr.each_with_index do |element, idx|
     return idx if element
    end
    0
  end
end

queue = CircularQueue.new(3)
puts queue.dequeue == nil
queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1
queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil