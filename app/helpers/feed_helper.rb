module FeedHelper

  def render_activity_description(activity)
    result = activity.action.humanize.downcase
    case activity.item_type
      when 'Recipe'
        result << '&nbsp;recipe&nbsp;' << span(link_to(h(activity.item.name), polymorphic_path(activity.item), :class => 'recipe_feed_image_thumb'), :class => 'item_name')
      when 'Blog'
        result << '&nbsp;blog&nbsp;' << span(link_to(h(activity.item.title), polymorphic_path(activity.item)), :class => 'item_name')
      when 'Ingredient'
        result << '&nbsp;ingredient&nbsp;' << span(link_to(h(activity.item.name), polymorphic_path(activity.item)), :class => 'item_name')
      when 'Follower'
        result = "#{link_to(h(activity.item.follower.name), profile_path(activity.item.follower))} has started following #{link_to(activity.item.following.name, profile_path(activity.item.following))}"
      when 'RecipeByOthers'
        result = "tried recipe #{link_to h(activity.item.recipe.name), recipe_path(activity.item.recipe), :class => 'recipe_feed_image_thumb'}"
      else
        case activity.action
          when 'badge'
            result = activity.extra
        end
    end
    result
  end

end
