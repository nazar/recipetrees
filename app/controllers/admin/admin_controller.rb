class Admin::AdminController < ApplicationController

  before_filter :login_required
  before_filter :check_admin


  def index
    @page_title = 'Admin >> Dashboard'
  end

  def recalc_nut_recent
    Recipe.transaction do
      Recipe.not_done_nutritions.all(:include => [{:recipe_ingredients => :measure}]).each do |recipe|
        recipe.calculate_nutrition
        recipe.done_nutrition_at = Time.now
        recipe.save(:without_revision => true)
      end
    end
    redirect_to '/admin/admin'
  end

  def recalc_nut_all
    Recipe.transaction do
      Recipe.all(:include => [{:recipe_ingredients => :measure}]).each do |recipe|
        recipe.calculate_nutrition
        recipe.done_nutrition_at = Time.now
        recipe.save(:without_revision => true)
      end
    end
    redirect_to '/admin/admin'
  end

  protected

  def check_admin
    if current_user
      if current_user.admin?
        return true
      end
    end
    render :text => 'Not authorised to access this area.', :layout => true, :status => 401
  end


end