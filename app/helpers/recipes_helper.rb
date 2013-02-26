module RecipesHelper

  def setup_recipe(recipe)
    returning(recipe) do |r|
      r.recipe_ingredients.build if r.recipe_ingredients.blank?
      r.steps.build(:step_no => 1) if r.steps.blank?
    end
  end

  def generate_html(form_builder, method, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
    options[:partial] ||= method.to_s.singularize
    options[:form_builder_local] ||= :f

    form_builder.fields_for(method, options[:object], :child_index => 'NEW_RECORD') do |f|
      render(:partial => options[:partial], :locals => { options[:form_builder_local] => f })
    end
  end

  def generate_template(form_builder, method, options = {})
    escape_javascript generate_html(form_builder, method, options)
  end

  def filter_session_to_string
    session[:filter].blank? ? [] : session[:filter]
  end

  def render_recipe_categories_for_ajax_click(recipe)
    recipe.categories.sort{|a,b| a.name <=> b.name }.inject([]) do |result, category|
      result << link_to(category.name, '#', :class => 'category_link', :data_category => "#{category.id}:#{category.name}")
    end.join(', ')
  end

  def render_recipe_categories_as_filters(recipe)
    recipe.categories.sort{|a,b| a.name <=> b.name }.inject([]) do |result, category|
      result << link_to(span(category.name, :property => 'v:recipeType', :content => category.name), "/recipes/filter?filter=c:#{category.id}:#{category.name}", :method => :post)
    end.join(', ')
  end

  def render_recipe_tags_for_ajax_click(tags)
    tags.sort{|a,b| a.name <=> b.name}.inject([]) do |result, tag|
      result << link_to(h(tag.name), "#", :class => 'tag_link', :data_tag => "#{tag.id}:#{tag.name}")
    end.join(', ')
  end

  def render_recipe_tags_as_filters(tags)
    tags.sort{|a,b| a.name <=> b.name}.inject([]) do |result, tag|
      result << link_to(h(tag.name), "/recipes/filter?filter=t:#{tag.id}:#{tag.name}", :method => :post)
    end.join(', ')
  end

  def cache_recipe_block(fragment, &block)
    if action_name == 'index'
      cache(:action => :index, :action_suffix => fragment) do
        concat capture(&block)
      end
    else
      concat capture(&block)
    end
  end

  def recipe_totals(recipes, field, ratio)
    recipes.inject(0.0){|total, recipe| total + (recipe.send(field).to_f/ratio.to_f).roundify}
  end

  def styled_recipe_totals(recipes, field, weight = '', ratio = 1)
    content_tag(:strong, recipe_totals(recipes, field, ratio).pretty_roundify + weight)
  end

  def recipe_subtotals(recipes, field, weight='', ratio = 1)
    if recipes.length > 1
      recipes.sort{|a,b| a.name <=> b.name}.inject('') do |result, recipe|
        result << content_tag(:div, :class => 'sub') do
          if recipe.id == recipes.last.id
            "#{h(recipe.name)} #{(recipe.send(field)/ratio.to_f).pretty_roundify}#{weight}"
          else
            "#{link_to(h(recipe.name), recipe_path(recipe))} #{(recipe.send(field).to_f/ratio.to_f).pretty_roundify}#{weight}"
          end
        end
      end
    end
  end


end
