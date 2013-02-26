module CategoriesHelper

  def categories_full_hierarchical_hash_to_grouped_options(selected = nil)
    cats = Category.sort_categories_hash( Category.full_tree_hierarchy_hash )
    selected = selected.blank? ? nil : selected.collect{|s| s.id}
    returning(String.new) do |html|
      html << cats.inject('') do |result, group|
        result << content_tag(:optgroup, :label => group.first.name) do
          options_from_collection_for_select(group.last, 'id', 'name', selected)
        end
      end
    end
  end

  def categories_check_boxes(recipe_scope = {})
    roots = Category.top_level_hash
    available = Category.categories_with_member_count(recipe_scope)
    #1. construct root => [cats] TODO... spin out into a method?
    built = available.inject({}) do |tree, category|
      if tree[ roots[category.parent_id] ].blank?
        tree[ roots[category.parent_id] ] = [category]
      else
        tree[ roots[category.parent_id] ] << category
      end
      tree
    end
    #2. build
    Category.sort_categories_hash(built).inject(String.new) do |result, group|
      result << returning(String.new) do |html|
        html << content_tag(:h5, group.first.name, :class => 'category_header') +
                group.last.inject('') do |boxes, category|
                  boxes << (check_box_tag(category.name, category.id, false, {:class => 'category_box'}) +
                          '&nbsp;' + category.name + " (#{category.recipes_count})" + '<br />')
                end

      end
    end
  end


end