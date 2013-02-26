module IngredientsHelper

  require 'graphviz'

  def build_recipes_array(recipe)
    recipe.recipe_ingredients.inject([recipe]) do |result, recipe_ingredient|
      case recipe_ingredient.recipe_item_type
        when Recipe.class_name
          unless result.include?(recipe_ingredient.recipe_item) #prevents infinite recursion
            result << build_recipes_array(recipe_ingredient.recipe_item)
          end
          result
        else
          result
      end
    end
  end

  def recipe_ingredient_line(recipe_ingredient)
    measure = recipe_ingredient.measure.name.gsub('Each - ', '')
    measure = measure.gsub('Each','')
    unit    = (recipe_ingredient.unit.to_f - recipe_ingredient.unit.to_i) > 0 ? recipe_ingredient.unit : recipe_ingredient.unit.to_i
    unless recipe_ingredient.recipe_item.blank?
      item         = span(h(recipe_ingredient.recipe_item.name), :property => 'v:name')
      unit_measure = span("#{unit} #{measure}", :property => 'v:amount')
      if recipe_ingredient.recipe_item_type == 'Ingredient'
        image = recipe_ingredient.recipe_item.image_file_name.blank? ? '' : '&nbsp;&nbsp;' + image_tag('ingredient_image.png', :class => 'ingredient_image_hook', :data_path => ingredient_image_path(recipe_ingredient.recipe_item))
      elsif recipe_ingredient.recipe_item_type == 'Recipe'
        image = recipe_ingredient.recipe_item.image_file_name.blank? ? '' : '&nbsp;&nbsp;' + image_tag('ingredient_image.png', :class => 'ingredient_image_hook', :data_path => image_recipe_path(recipe_ingredient.recipe_item))
      else
        image = ''
      end
      #
      content_tag :span, :rel => 'v:ingredient' do
        content_tag :span, :typeof => 'v:Ingredient' do
          "#{unit_measure} #{link_to item, polymorphic_path(recipe_ingredient.recipe_item)}#{image}" unless recipe_ingredient.recipe_item.blank?
        end
      end
    else
      ''
    end
  end

  def ingredient_description_or_blank(ingredient)
    if ingredient.description.blank?
      "This ingredient has no description. Be the first to #{link_to 'write', edit_ingredient_path(ingredient)} about #{h(ingredient.name).pluralize}"
    else
      from_textile(ingredient.description)
    end
  end

  def ingredient_line_with_relation(ingredient, current_ingredient)
    name = link_to(h(ingredient.name), ingredient_path(ingredient))
    if admin?
      delete = content_tag(:span,
                           link_to(image_tag('action_stop.gif', :align => "middle"),
                                   remove_ingredient_relation_path(ingredient.ingredient_relation_hold, current_ingredient.id)) <<
        "&nbsp; #{ingredient.ingredient_relation_hold}" )
    else
      delete = ''
    end
    name << delete
  end

  def generate_relations_image(relations, current_ingredient)
    # initialize new Graphviz graph
    g = GraphViz::new( "structs", "type" => "graph" )
    g[:rankdir] = "TB"
    g["size"] = "8,8"
    # set global node options
    g.node[:color]    = "#ddaa66"
    g.node[:style]    = "filled"
    g.node[:shape]    = "box"
    g.node[:penwidth] = "1"
    g.node[:fontsize] = "10"
    g.node[:fillcolor]= "#ffeecc"
    g.node[:fontcolor]= "#775500"
    g.node[:margin]   = "0.1"

    # set global edge options
    g.edge[:color]    = "#999999"
    g.edge[:weight]   = "1"
    g.edge[:fontsize] = "8"
    g.edge[:fontcolor]= "#444444"
    g.edge[:dir]      = "forward"
    g.edge[:arrowsize]= "0.5"


    #iterate through relations and build nodes
    relations.each do |ingredient|
      node = g.add_node(ingredient.id.to_s)
      node.label = h(ingredient.name)
      node.fillcolor = "#ffffff" if ingredient.id == current_ingredient.id
    end

    #get relation objects
    ingredient_relation_ids = relations.collect{|ingredient| ingredient.ingredient_relation_hold}
    ingredient_relations = IngredientRelation.all :conditions => {:id => ingredient_relation_ids}

    #build edges
    ingredient_relations.each do |ingredient_relation|
      edge = g.add_edge(ingredient_relation.ingredient_id.to_s, ingredient_relation.relation_id.to_s)
      edge.label = ingredient_relation.id.to_s
    end

    #build image
    file_name = Rails.root.join('public', 'images', 'graphs', "ingredient_#{current_ingredient.id}.png")
    g.output( "output" => "png", :file => file_name )

    #finally, return image_to to file
    image_tag ['graphs', "ingredient_#{current_ingredient.id}.png"].join('/'), :class => 'graph'
  end

  def ingredients_check_boxes(recipes_scope)
    #build into hash => ingredient_group_name => [ingredient, ingredient]
    root = Ingredient.ingredient_groups
    ingredients = Ingredient.ingredients_with_recipes_count(recipes_scope).inject({}) do |list, ingredient|
      name = root[ingredient.ingredient_group]
      if list[ name ].nil?
        list[ name ] = [ingredient]
      else
        list[ name ] << ingredient
      end
      list
    end
    #construct checkboxes with group headers
    ingredients.sort{|a,b| a.first <=> b.first}.inject(String.new) do |result, ingredient|
      result << returning(String.new) do |html|
        html << content_tag(:h5, ingredient.first.humanize, :class => 'category_header') +
                ingredient.last.inject('') do |boxes, this_ingredient|
                  boxes << (check_box_tag(h(this_ingredient.name), this_ingredient.id, false, {:id => "ingredient_#{this_ingredient.name}", :class => 'ingredient_box'}) +
                          '&nbsp;' + h(this_ingredient.name) + " (#{this_ingredient.recipes_count})" + '<br />')
                end
      end
    end
  end

  def ingredient_group_options
    @ingredient_group_options ||= Ingredient.ingredient_groups.sort{|a,b| a.last <=> b.last }.collect{|i| [i.last, i.first]}
  end

  def ingredient_group_to_s(group)
    Ingredient.ingredient_groups[group.to_i]
  end

  def ingredient_category_links
    roots = Ingredient.ingredient_groups
    Ingredient.category_groups_with_count_array.sort{|a,b| roots[a.ingredient_group.to_i] <=> roots[b.ingredient_group.to_i]}.inject([]) do |result, category|
      klass = action_name == 'by_category' ? (params[:id] == roots[category.ingredient_group] ? 'selected' : nil )  : nil
      result << link_to( "#{roots[category.ingredient_group].humanize} (#{category.ingredients_count})", by_category_ingredient_path(roots[category.ingredient_group]), :class => klass )
    end.join('<br />')
  end

  #generates A-Z ingredient list
  def ingredient_alphabet_list
    s_letters = 'A'..'Z'
    a_letters = Ingredient.ingredient_alphabet
    content_tag(:ul, :class => 'alphabet_filter') do
      returning('') do |result|
        for letter in s_letters
          unless a_letters[letter].nil?
            result << content_tag(:li, link_to(letter, filter_ingredient_path(letter), :title => pluralize(a_letters[letter], 'Ingredient')) )
          else
            result << content_tag(:li, content_tag(:span, letter, :class => 'empty'))
          end
        end
      end
    end
  end

end
