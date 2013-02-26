class Nutrition < ActiveRecord::Base

  require 'open-uri'
  require 'hpricot'

  include FatSecret

  belongs_to :ingredient

  attr_accessor :serving_amount

  #class methods


  def self.get_foods_from_fs_for_ingredient(ingredient)
    foods_search(ingredient.name)
  end

  def self.get_servings_for_food_id(food_id)
    food_get(food_id)
  end


  #instance methods

  def update_from_params(params)
    #get factor incase we don't have a 100 serving_amount
    factor             = params[:serving_amount].to_f / 100.00
    #
    self.serving_id    = params[:serving_id]
    self.cholesterol   = params[:cholesterol]
    self.serving_url   = params[:serving_url]
    self.each_grams    = params[:each_grams]
    #adjust by factor
    self.protein       = params[:protein].to_f * factor
    self.fat           = params[:fat].to_f * factor
    self.sugar         = params[:sugar].to_f * factor
    self.sodium        = params[:sodium].to_f * factor
    self.potassium     = params[:potassium].to_f * factor
    self.carbohydrate  = params[:carbohydrate].to_f * factor
    self.saturated_fat = params[:saturated_fat].to_f * factor
    self.calories      = params[:calories].to_f * factor
    self.fiber         = params[:fiber].to_f * factor
    #
    scrape_table
  end

  def scrape_table
    unless serving_url.blank?
      doc = Hpricot(open(serving_url))
      el = doc/'table.generic div.nutpanel'
      self.nutrition_table = el.innerHTML unless el.blank?
    end
  end

end
