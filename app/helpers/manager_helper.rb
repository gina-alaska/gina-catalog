module ManagerHelper
  def awesome_set_options(class_or_item, value_field = :id, mover = nil)
    if class_or_item.is_a? Array
      items = class_or_item.reject { |e| !e.root? }
    else
      class_or_item = class_or_item.roots if class_or_item.respond_to?(:scoped)
      items = Array(class_or_item)
    end
    result = []
    items.each do |root|
      result += root.class.associate_parents(root.self_and_descendants).map do |i|
        if mover.nil? || mover.new_record? || mover.move_possible?(i)
          [yield(i), i.send(value_field)]
        end
      end.compact
    end
    result
  end

  def breaking_word_wrap(txt, col = 80)
    txt.gsub(/(.{1,#{col}})( +|$\n?)|(.{1,#{col}})/,
      "\\1\\3\n") 
  end
end
