class RecipeIngredient < ActiveRecord::Base

  belongs_to :measure
  belongs_to :recipe

  belongs_to :recipe_item, :polymorphic => true


  validates_presence_of :unit, :recipe_item_id, :if => Proc.new { |ri| not Recipe.draft(ri.edited_by || ri.recipe.created_by_id) }
  validates_numericality_of :unit, :greater_than => 0.0, :if => Proc.new { |ri| not Recipe.draft(ri.edited_by || ri.recipe.created_by_id) }



  named_scope :order_by_type, :order => 'recipe_item_type asc'
  named_scope :recipes, :conditions => ['recipe_item_type = ?', 'Recipe']
  named_scope :ingredients, :conditions => ['recipe_item_type = ?', 'Ingredient']

  attr_accessor :name, :edited_by

  acts_as_revisable

  #class methods

  #instance methods

  def name
    unless recipe_item_id.blank?
      case recipe_item_type
        when "Ingredient"; recipe_item.name
        when "Recipe"; recipe_item.name
      end
    end
  end

  def ingredient_group
    unless recipe_item_id.blank?
      case recipe_item_type
        when "Ingredient"; recipe_item.ingredient_group
        when "Recipe"; -1
      end
    end
  end

  def cloneable_attributes
    to_clone = ['recipe_item_id', 'recipe_item_type', 'measure_id', 'unit']
    attributes.inject({}) do |result, attribute|
      result.merge( to_clone.include?(attribute.first) ? {attribute.first => attribute.last} : {} )
    end
  end

  def calculate(field)
    result = 0.0
    if recipe_item_type == 'Ingredient'
      unless recipe_item.nutrition.blank?
        if measure.name =~ /each/i
          ratio = (measure.ratio.to_f * recipe_item.nutrition.each_grams.to_f) / 100.00
        else
          ratio = measure.ratio.to_f
        end
        result = unit * ratio * recipe_item.nutrition.send(field).to_f
      end
    end
    result
  end



end
