class Ingredient < ActiveRecord::Base

  has_many :ingredient_relations
  has_many :relations, :through => :ingredient_relations

  has_many :recipe_ingredients, :as => :recipe_item, :dependent => :delete_all, :conditions => 'recipe_ingredients.revisable_is_current = 1'
  has_many :recipes, :through => :recipe_ingredients, :source => :recipe, :foreign_key => 'recipe_item_id', :class_name => 'Recipe'

  has_many :images, :as => :imageable

  has_one :nutrition

  belongs_to :user
  belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by_id'


  accepts_nested_attributes_for :images, :allow_destroy => true


  validates_uniqueness_of :name, :scope => :revisable_is_current
  validates_presence_of :name


  has_attached_file :image,
                    :styles => { :original => ['350x250#', 'jpg'], :thumbnail => ['50x50#', 'jpg']  },
                    :default_style => :original,
                    :convert_options => { :all => "-strip" },
                    :default_url => "/images/no_:style_ingredient.png"

  acts_as_activity

  acts_as_revisable do
    except [:ingredient_group, :food_id, :recipes_count, :posts_count, :images_count, :views_count ]
  end

  after_save :clear_all_caches


  attr_accessor :ingredient_relation_hold

  IngredientGroupSpice   = 1
  IngredientGroupHerb    = 2
  IngredientGroupFruit   = 3
  IngredientGroupVeg     = 4
  IngredientGroupGrain   = 5
  IngredientGroupDairy   = 6
  IngredientGroupMeat    = 7
  IngredientGroupCond    = 8
  IngredientGroupOil     = 9
  IngredientGroupOther   = 10
  IngredientGroupPulses  = 11
  IngredientGroupUnknown = 100


  named_scope :by_name, :order => 'name asc'
  named_scope :grouped, :group => 'ingredient_group asc'
  named_scope :category_groups_with_count, :select => 'ingredients.ingredient_group, count(1) ingredients_count',
                                    :group => 'ingredients.ingredient_group asc'
  named_scope :ids_only, :select => 'ingredients.id'
  named_scope :name_search, lambda{|search|
    {:conditions => ['ingredients.name like ?', "%#{search}%"]}
  }
  named_scope :not_id, lambda{|not_id|
    {:conditions => ['id <> ?', not_id]}
  }
  named_scope :by_name_array, lambda{|names|
    { :conditions => {:name => names} }
  }
  named_scope :by_id_array, lambda{|ids|
    { :conditions => {:id => ids} }
  }
  named_scope :by_category, lambda{|ingredient_group|
    { :conditions => {:ingredient_group => ingredient_group} }
  }
  named_scope :by_alphabet, lambda{|letter|
    {:conditions => ['ingredients.name like ?', "#{letter}%"]}
  }



  #scoped methods

  def self.ingredients_with_recipes_count(recipe_scope = {})
    recipe_conditions = recipe_scope.blank? ? {} : recipe_scope.current_scoped_methods[:find]
    #
    scoped( {
      :select => 'ingredients.id, ingredients.ingredient_group ,ingredients.name, count(1) recipes_count',
      :joins => 'inner join recipe_ingredients on recipe_ingredients.recipe_item_id = ingredients.id and recipe_ingredients.recipe_item_type = "Ingredient" and recipe_ingredients.revisable_is_current = 1 ' <<
                'inner join recipes on recipe_ingredients.recipe_id = recipes.id and recipes.revisable_is_current = 1 ',
      :group => 'ingredients.name'
   }.merge(recipe_conditions) )
  end

  def self.ingredient_alphabet
    Ingredient.find(:all, :select => 'ucase(left(name, 1)) a, count(id) c', :group => 'left(name, 1)').inject({}) do |out, ingredient|
      out.merge(ingredient.a => ingredient.c)
    end
  end



  #class methods

  class << self
    extend ActiveSupport::Memoizable

    def ingredient_groups
      {Ingredient::IngredientGroupUnknown => 'unknown', Ingredient::IngredientGroupSpice => 'spice', Ingredient::IngredientGroupHerb => 'herb',
       Ingredient::IngredientGroupFruit => 'fruit', Ingredient::IngredientGroupGrain => 'nuts, grain & cereal', Ingredient::IngredientGroupVeg => 'vegetable',
       Ingredient::IngredientGroupDairy => 'dairy', Ingredient::IngredientGroupMeat => 'meat', Ingredient::IngredientGroupCond => 'condiment',
       Ingredient::IngredientGroupOil => 'oils', Ingredient::IngredientGroupOther => 'other', Ingredient::IngredientGroupPulses => 'beans & pulses'}
    end

    def category_groups_with_count_array
      Ingredient.category_groups_with_count.all
    end
    memoize :category_groups_with_count_array

    def clear_caches
      flush_cache(:category_groups_with_count_array)
    end

    def related_ingredient_ids(ingredient)
      begin
        related_ids = ActiveRecord::Base.connection.select_all("call RelatedIngredientIDs(#{ingredient.id});")
      ensure
        ActiveRecord::Base.connection.reconnect!
      end
      related_ids
    end

    def related_ingredient_ids_to_a(ingredient)
      related_hash = Ingredient.related_ingredient_ids(ingredient)
      related_hash.inject([]){|result, element| result << element["nodeID"].to_i}
    end

    def select_from_filter(params)
      params.select{|a| a =~ /^i:/}
    end

    def get_ids_from_filter(params)
      params.collect{|x| x.match('^i:(\d+):')[1] }
    end

  end


  #instance methods

  def to_param
    "#{id}_#{name.to_permalink}"
  end

  def label
    name
  end

  def value
    name
  end

  def related_ingredients
    related_ids = Ingredient.related_ingredient_ids(self)
    ingredient_ids = related_ids.inject([]){|result, hash| result << hash["nodeID"].to_i }
    ingredient_relations = related_ids.inject({}){|result, hash| result.merge({hash["nodeID"].to_i => hash["ir_id"]})}
    ingredients = Ingredient.all :conditions => {:id => ingredient_ids}
    ingredients.inject([]){|result, ingredient| ingredient.ingredient_relation_hold = ingredient_relations[ingredient.id]; result << ingredient}
  end

  def to_filter_s
    "i:#{id}:#{name.humanize}"
  end

  def hit_views!
    Ingredient.increment_counter(:views_count, self.id)
  end

  def valid_nutrition_info
    nutrition && (not nutrition.serving_url.blank?)
  end

  def previously_revised_by_same_user
    if revisable_number.to_i == 0
      false
    else
      previous = find_revision(:previous)
      (previous.updated_by_id || previous.user_id) == updated_by_id
    end
  end


  private

  def clear_all_caches
    Ingredient.clear_caches
  end



end
