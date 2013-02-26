module RtTagsHelper

  def tag_check_boxes(recipes_scope)
    recipe_conditions = recipes_scope.blank? ? {} : recipes_scope.current_scoped_methods[:find]
    Recipe.tag_counts(recipe_conditions).sort{|a,b| a.name <=> b.name}.inject(String.new) do |result, tag|
      result << (check_box_tag(h(tag.name), tag.id, false, {:id => "tag_#{h(tag.name)}", :class => 'tag_box'}) +
              '&nbsp;' + h(tag.name) + " (#{tag.count})" + '<br />')
    end
  end

end
