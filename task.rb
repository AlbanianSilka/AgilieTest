# frozen_string_literal: true

# Main class to create handlers
class PackHandler
  attr_reader :handled_items, :identifiers

  # initializer for items and our identifiers
  def initialize
    @handled_items = []
    @identifiers = []
  end

  # method to add new identifiers
  def identify(item)
    @identifiers.push item
  end

  # method to proc items, where it will take 'items' and if valid - get them into @handled_items array
  def proc_items(items)
    items.each do |item|
      # firstly we will skip item if it already presented in @handled_items
      next if @handled_items.include? item

      # next we check if our item is a hash
      if item.is_a?(Hash)
        # then we took key and value from the hash
        item.each do |key, value|
          # check for presence in identifiers, if not - skip
          next unless @identifiers.include?(key)

          # method to skip item if it was already presented with its identifier
          item = nil if @handled_items.find { |h| h[key] == value }
          @handled_items.push item unless item.nil?
        end
      else
        # finally - push item to @handled_items
        @handled_items.push item
      end
    end
    puts(@handled_items.to_s)
  end

  # method to clear @handled_items array
  def reset
    @handled_items.clear
    puts('Packer has been successfully reset')
  end
end

# class with help of which we will be enable to add items to PackHandler
class SomeClass
  attr_reader :main_field

  def initialize(main_field)
    @main_field = main_field
  end
end

# Showing all of our actions
a = SomeClass.new([1, 2, 3, 4])
b = SomeClass.new([5, 6, 2, 1])
packer = PackHandler.new
packer.identify('id')
packer.proc_items(a.main_field)
packer.proc_items(b.main_field)
packer.reset

hash1 = SomeClass.new([{ 'not_id' => 3 }, { 'id' => 1 }, { 'id' => 1, 'text_value' => 'text' }, { 'id' => 2 }])
hash2 = SomeClass.new([{ 'id' => 2 }, { 'id' => 3 }])

packer.proc_items(hash1.main_field)
packer.proc_items(hash2.main_field)
