require  'pry-byebug'

class Array
  def merge_sort
    sorted = []
    if length < 2
      sorted << self[0]
    else
      arr1 = slice!(0, length / 2)
      left = arr1.merge_sort
      right = merge_sort
      counter = left.length + right.length
      counter.times do
        if left.length.zero? || right.length.zero?
          sorted += right + left
          break
        end
        if left[0] < right[0]
          sorted << left.shift(1)[0]
        else
          sorted << right.shift(1)[0]
        end
      end
    end
    sorted
  end
end

class Node
  include Comparable
  attr_accessor :left, :right, :data

  def initialize(data = nil, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  def <=>(other)
    data <=> other.data
  end
end

class Tree
  def initialize(array)
    @array = array
    @root = build_tree(array.uniq.merge_sort)
  end

  def build_tree(array)
    return nil if array[0].nil?
    root = Node.new(array[array.length / 2])
    return root if array.length < 2

    root.left = build_tree(array.slice(0, array.length / 2))
    root.right = build_tree(array.slice((array.length / 2) + 1, array.length - 1))
    root
  end

  def insert(data, root = @root)
    if data < root.data
      if root.left.nil?
        root.left = Node.new(data)
      else
        insert(data, root.left)
      end
    elsif data > root.data
      if root.right.nil?
        root.right = Node.new(data)
      else
        insert(data, root.right)
      end
    end
  end

  def insert_node(node, root = @root)
    if root.data.nil?
      root = node 
      return
    end

    if node.data < root.data
      if root.left.nil?
        root.left = node
      else
        insert_node(node, root.left)
      end
    elsif node.data > root.data
      if root.right.nil?
        root.right = node
      else
        insert_node(node, root.right)
      end
    end
  end

  def find(data, root = @root)
    return nil if root.nil?
    return root if data == root.data
    return find(data, root.right) if data > root.data
    return find(data, root.left) if data < root.data
  end

  def delete(data, root = @root)
    return nil if root.nil?

    if data > root.data
      root.right = delete(data, root.right)
    elsif data < root.data
      root.left = delete(data, root.left)
    end
    if data == root.data
      if root.right.nil?
        root = root.left
      elsif root.left.nil?
        root = root.right
      else
        left = root.left
        root = root.right
        insert_node(left, root) unless left.nil?
      end
    end
    @root = root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def level_order(queue = [@root], &block)
    return nil if queue.empty?

    if block_given?
      block.call(queue[0])
      queue.push(queue[0].left) unless queue[0].left.nil?
      queue.push(queue[0].right) unless queue[0].right.nil?
      queue.shift
      level_order(queue, &block)
      queue
    else
      result = []
      level_order { |node| result << node.data }
      result
    end
  end

  #Add root to the stack, if it has a left node, call inorder to it
  #If no more left nodes are present, pop last value of stack to result
  #If that value has a right node, add value to stack after popping
  #return result if stack is empty
  def inorder(root = @root, stack = [], result = [], &block)

    return nil if root.nil?
    if inorder(root.left, stack << root, result, &block).nil?
      block.call(stack[-1]) if block_given?
      result << stack.pop.data
      if inorder(root.right, stack, result, &block).nil?
        result
      end
    else
      result
    end
    result if stack.empty?
  end
end
# arr = Array.new(10) { rand(1...200) }
arr = [8, 9, 20, 60, 100, 800]
new_tree = Tree.new(arr)
new_tree.pretty_print
rnd = 50
puts "Inserting #{rnd}..."
new_tree.insert(rnd)
new_tree.insert(10)
# new_tree.pretty_print
# rmv = arr.sample
# puts "Removing #{rmv}..."
# new_tree.delete(rmv)
# new_tree.level_order { |node| node.right.data += 5 unless node.right.nil?}
new_tree.pretty_print
p new_tree.inorder 
new_tree.pretty_print 
