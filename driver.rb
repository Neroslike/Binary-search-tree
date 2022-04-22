require_relative 'main.rb'

arr = (Array.new(15) { rand(1..100) })
tree = Tree.new(arr)
tree.pretty_print
puts tree.balanced? ? 'The tree is balanced' : 'The tree is not balanced'
p tree.level_order
p tree.preorder
p tree.postorder
p tree.inorder
6.times do
  tree.insert(rand(100..200))
end
tree.pretty_print
puts tree.balanced? ? 'The tree is balanced' : 'The tree is not balanced'
tree.rebalance
tree.pretty_print
puts tree.balanced? ? 'The tree is balanced' : 'The tree is not balanced'
p tree.level_order
p tree.preorder
p tree.postorder
p tree.inorder
