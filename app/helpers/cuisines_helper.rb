module CuisinesHelper

  def cuisines_check_boxes(recipes_scope)
    Cuisine.cuisines_with_recipes_count(recipes_scope).inject(String.new) do |result, cuisine|
      result << (check_box_tag(cuisine.name, cuisine.id, false, {:id => "cuisine_#{cuisine.name}", :class => 'cuisine_box'}) +
              '&nbsp;' + cuisine.name + " (#{cuisine.recipes_count})" + '<br />')
    end
  end

end