class RelationsController < ApplicationController

  before_filter :login_required

  def add
    if admin?
      ingredient_id = params[:id]
      links_to_id = params[:ingredient_relation_id]
      if (ingredient_id.to_i > 0) && (links_to_id.to_i > 0)
        IngredientRelation.link_ingredients(ingredient_id, links_to_id)
      end
      redirect_to ingredient_path(ingredient_id)
    else
      head :status => 403
    end
  end

  def remove
    if admin?
      ingredient_relation_id = params[:ingredient_relation_id].to_i
      if ingredient_relation_id > 0
        IngredientRelation.delete(ingredient_relation_id)
      end
      redirect_to ingredient_path(params[:ingredient_id])
    else
      head :status => 403
    end
  end


end
