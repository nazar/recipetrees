class Recipe < ActiveRecord::Base

  has_many :recipe_ingredients, :dependent => :delete_all,
           :conditions => 'recipe_ingredients.revisable_is_current = 1', :before_add => :set_tmp_link

  has_many :ingredients, :through => :recipe_ingredients, :source => :recipe_item, :source_type => 'Ingredient',  :order => 'ingredients.name asc'

  #relations for recipes that use this recipe as a sub-recipe
  has_many :inverse_recipes, :class_name => 'RecipeIngredient', :foreign_key => 'recipe_item_id', :conditions => ['recipe_ingredients.recipe_item_type = ?', 'Recipe']
  has_many :sub_recipes, :through => :inverse_recipes, :source => :recipe, :order => 'recipes.name asc'

  #relations for recipes that are referenced as sub-recipes against this recipe
  has_many :recipe_ingredients_recipes, :class_name => 'RecipeIngredient',
           :conditions => ['recipe_ingredients.revisable_is_current = 1 and recipe_ingredients.recipe_item_type = ?', Recipe.class_name]
  has_many :recipes_used_in_this, :through => :recipe_ingredients_recipes, :source => :recipe_item, :source_type => 'Recipe'

  has_many :steps, :order => 'steps.step_no asc', :dependent => :delete_all,
           :conditions => 'steps.revisable_is_current = 1', :before_add => :set_tmp_link

  has_many :other_images, :as => :imageable
  has_many :recipe_forks
  has_many :recipe_watchers
  has_many :by_others, :class_name => 'RecipeByOthers'
  has_many :watchers, :class_name => 'User', :through => :recipe_watchers,
      :select => 'users.id, users.name, users.facebook_id', :source => :user

  has_one :forked_from, :class_name => 'RecipeFork', :foreign_key => 'to_recipe_id'

  belongs_to :cuisine
  belongs_to :cooking_method
  belongs_to :user, :foreign_key => 'created_by_id'

  accepts_nested_attributes_for :steps, :recipe_ingredients, :recipe_forks, :allow_destroy => true

  acts_as_taggable
  acts_as_rateable
  acts_as_activity

  has_attached_file :image,
                    :styles => { :original => ['350x250#', 'jpg'], :thumbnail => ['75x75#', 'jpg']  },
                    :default_style => :original,
                    :convert_options => { :all => "-strip" },
                    :default_url => "/images/no_:style_ingredient.png"



  validates_presence_of :name
  validates_presence_of :description, :serves_from, :serves_to, :cuisine_id,
                        :steps, :recipe_ingredients, :categories, :tag_list,
                        :if => Proc.new { |recipe| recipe.is_draft == false }

  validates_attachment_presence :image, :if => Proc.new { |recipe| recipe.is_draft == false }

  validates_uniqueness_of :name, :scope => [:created_by_id, :revisable_is_current]

  acts_as_revisable do
    except [:views_count, :topics_count, :posts_count, :favourites_count, :forks_count, :facebook_published_at,
            :ingredients_count, :ratings_count, :ratings_total, :recipes_count, :watchers_count, :is_draft,
            :total_fiber, :total_protein, :total_fat, :total_sugar, :total_sodium, :total_calories, :total_carbohydrate,
            :total_saturated_fat, :total_cholesterol, :done_nutrition_at, :facebook_app_published_at]
  end

  attr_accessor :recipe_fork_hold

  @@drafts = {}


  after_revise :revise_associations
  before_save :calculate_recipe_time
  after_save :clear_draft_flag



  #shows original recipes or recipes that have been forked and further edited. Don't show purely forked recipes in index
  named_scope :active, :conditions => '(recipes.forked_from_id is null) or ((recipes.forked_from_id is not null) and (recipes.revisable_number > 0))'
  named_scope :original, :conditions => '(recipes.forked_from_id is null) or ((recipes.forked_from_id is not null) and (recipes.revisable_number > 5))'
  named_scope :published, :conditions => ['recipes.is_draft = ?', false]
  named_scope :draft, :conditions => ['recipes.is_draft = ?', true]
  named_scope :by_name, :order => 'recipes.name asc'
  named_scope :latest, :order => 'recipes.created_at DESC'
  named_scope :not_done_nutritions, :conditions => 'done_nutrition_at is null'
  named_scope :not_id, lambda{|id|
    {:conditions => ['recipes.id <> ?', id]}
  }
  named_scope :limit, lambda{|limit|
    {:limit => limit}
  }
  named_scope :name_search, lambda{|search|
    {:conditions => ['recipes.name like ?', "%#{search}%"]}
  }
  named_scope :search_by_title, lambda{|title|
    {:conditions => ['recipes.name like ?', '%'+title+'%']}
  }
  named_scope :by_user, lambda{|user|
    {:conditions => ['recipes.created_by_id = ?', user.id]}
  }
  named_scope :good_recipes,
  {
    :conditions => 'ratings.rating between 4 and 5',
    :joins => 'inner join ratings on recipes.id = ratings.rateable_id and ratings.rateable_type = "Recipe"'
  }
  named_scope :bad_recipes,
  {
    :conditions => 'ratings.rating between 1 and 2',
    :joins => 'inner join ratings on recipes.id = ratings.rateable_id and ratings.rateable_type = "Recipe"'
  }

  #all recipes containing any of supplied ingredients
  named_scope :recipes_for_ingredient_ids, lambda{|ingredient_ids|
    sql = <<-END
      exists ( select recipe_id from recipe_ingredients where recipe_ingredients.recipe_id = recipes.id
               and recipe_ingredients.recipe_item_id in (?) and recipe_item_type = ? )

    END
    {
      :conditions => [sql, ingredient_ids, Ingredient.class_name]
    }
  }

  #contains all given ingredients
  named_scope :contain_ingredients_by_id, lambda{|ingredient_ids|
    sql = <<-END
      exists ( select recipe_id, count(1) from recipe_ingredients where recipe_ingredients.recipe_id = recipes.id
               and recipe_ingredients.recipe_item_id in (?) and recipe_item_type = ?
               group by recipe_id having count(1) = ?)

    END
    {
      :conditions => [sql, ingredient_ids, Ingredient.class_name, ingredient_ids.length]
    }
  }

  named_scope :contain_categories_by_id, lambda{|category_ids|
    sql = <<-END
      exists (select member_id, count(1)
             from categories_members where categories_members.member_id = recipes.id  and categories_members.member_type = ?
                  and categories_members.category_id in (?) group by member_id having count(1) >= ?  )
    END
    {
      :conditions => [sql, Recipe.class_name, category_ids, category_ids.length ]
    }
  }

  named_scope :contain_cuisines_by_id, lambda{|cuisine_ids|
    {
      :conditions => ['recipes.cuisine_id in (?)', cuisine_ids]
    }
  }

  named_scope :contains_tag_ids, lambda{|tag_ids|
    sql = <<-END
      exists (
        select taggable_id, count(1) from taggings
        where taggings.taggable_id = recipes.id and taggings.taggable_type = ?
        and taggings.tag_id in (?)
        group by taggable_id having count(1) >= ?
      )
    END
    {
      :conditions => [sql, Recipe.class_name, tag_ids, tag_ids.length ]
    }
  }

  #class methods

  def self.decide_scope(ingredient_ids, category_ids, cuisine_ids, tag_ids, title)
    start = Recipe.published
    start = start.contain_ingredients_by_id(ingredient_ids) unless ingredient_ids.blank?
    start = start.contain_categories_by_id(category_ids) unless category_ids.blank?
    start = start.contain_cuisines_by_id(cuisine_ids) unless cuisine_ids.blank?
    start = start.contains_tag_ids(tag_ids) unless tag_ids.blank?
    start = start.search_by_title(title) unless title.blank?
    start
  end

  def self.forked_recipe_ids(recipe)
    begin
      related_ids = ActiveRecord::Base.connection.select_all("call ForkedRecipeIDs(#{recipe.id});")
    ensure
      ActiveRecord::Base.connection.reconnect!
    end
    related_ids
  end


  def self.draft= (recipe)
    if recipe.is_draft
      @@drafts[recipe.created_by_id] = true
    else
      @@drafts.delete(recipe.created_by_id)
    end
  end

  def self.draft(created_by_id)
    @@drafts[created_by_id] == true
  end

  def self.draft_clear(created_by_id)
    @@drafts.delete(created_by_id)
  end

  def self.related_recipes_to_ingredient(ingredient)
    related_ingredients = Ingredient.related_ingredient_ids_to_a(ingredient) - [ingredient.id]
    published.recipes_for_ingredient_ids(related_ingredients)
  end




  #instance methods

  def to_param
    "#{id}_#{name.to_permalink}"
  end


  def can_edit(current_user)
    current_user && ( (current_user.id == created_by_id) || (current_user.admin) )
  end

  def my_recipe(current_user)
    current_user && (current_user.id.to_i == created_by_id.to_i)
  end

  def new_branch(user)
    new_name = user.id == created_by_id ? "Fork of #{name}" : name
    returning(branch(:name => new_name)) do |recipe|
      recipe.forked_from_id = self.id
      steps.each{|step| recipe.steps.build step.cloneable_attributes }
      recipe_ingredients.each {|ri| recipe.recipe_ingredients.build ri.cloneable_attributes}
      recipe.categories = categories
      recipe.recipe_forks.build(:from_recipe_id => self.id, :forked_by_id => user.id)
    end
  end

  def process_recipe(params, user)
    new_categories = params[:recipe][:categories].blank? ? nil : preprocess_recipe_categories(params)
    preprocess_recipe_items(params[:recipe][:recipe_ingredients_attributes], user)
    self.categories = new_categories unless new_categories.blank?
  end

  def forks
    related_ids = Recipe.forked_recipe_ids(self)
    recipe_ids = related_ids.inject([]){|result, hash| result << hash["nodeID"].to_i }
    recipe_forks = related_ids.inject({}){|result, hash| result.merge({hash["nodeID"].to_i => hash["rf_id"]})}
    recipes = Recipe.all :conditions => {:id => recipe_ids}
    recipes.inject([]){|result, recipe| recipe.recipe_fork_hold = recipe_forks[recipe.id]; result << recipe}
  end


  def clone_step_images_if_not_updated(steps_attributes)
    steps_attributes.each_pair do |key, value|
      step = steps.select{|s| s.step_no.to_s == value[:step_actual].to_s}.first
      if step.image_file_name.blank?
        orig_step = Step.find_by_id value[:cloned_from_id].to_i
        unless orig_step.blank?
          unless orig_step.image_file_name.blank?
            step.image = orig_step.image
            step.image.instance_write(:file_name, "step_#{orig_step.step_no}.jpg")
          end
        end
      end
    end
  end

  def hit_views!(current_user)
    if not my_recipe(current_user)
      Recipe.increment_counter(:views_count, self.id)
    end
  end

  def label
    name
  end

  def value
    name
  end

  def safe_id
    self.id.blank? ? "u_#{created_by_id}" : self.id
  end

  def calculate_nutrition
    calc_ingredients = recipe_ingredients.ingredients.all :include => [:measure, {:recipe_item => :nutrition}]
    #
    self.total_fiber         = calc_ingredients.inject(0.0){|sum, ri| sum + ri.calculate(:fiber) }
    self.total_protein       = calc_ingredients.inject(0.0){|sum, ri| sum + ri.calculate(:protein) }
    self.total_fat           = calc_ingredients.inject(0.0){|sum, ri| sum + ri.calculate(:fat)  }
    self.total_sugar         = calc_ingredients.inject(0.0){|sum, ri| sum + ri.calculate(:sugar)  }
    self.total_sodium        = calc_ingredients.inject(0.0){|sum, ri| sum + ri.calculate(:sodium) }
    self.total_potassium     = calc_ingredients.inject(0.0){|sum, ri| sum + ri.calculate(:potassium) }
    self.total_calories      = calc_ingredients.inject(0.0){|sum, ri| sum + ri.calculate(:calories) }
    self.total_carbohydrate  = calc_ingredients.inject(0.0){|sum, ri| sum + ri.calculate(:carbohydrate) }
    self.total_saturated_fat = calc_ingredients.inject(0.0){|sum, ri| sum + ri.calculate(:saturated_fat) }
    self.total_cholesterol   = calc_ingredients.inject(0.0){|sum, ri| sum + ri.calculate(:cholesterol) }
  end

  private


  def calculate_recipe_time
    self.total_time = steps.inject(0){|sum, step| sum + step.time_required_seconds} unless self.is_draft
  end

  def preprocess_recipe_items(recipe_ingredients, user)
    recipe_ingredients.each do |id, recipe_ingredient|
      if recipe_ingredient[:recipe_item_id].to_i == 0
        ingredient = Ingredient.find_or_initialize_by_name(recipe_ingredient[:name])
        if ingredient.new_record?
          ingredient.name.capitalize!
          ingredient.ingredient_group = Ingredient::IngredientGroupUnknown
          ingredient.user_id = user.id
          ingredient.save
          #new ingredient might be missing nutrition info... mark recipe as incomplete
          self.done_nutrition_at = nil
        end
        recipe_ingredient[:recipe_item_id] = ingredient.id
      end
    end unless recipe_ingredients.blank?
  end

  def preprocess_recipe_categories(params)
    Category.find(params[:recipe].delete(:categories))
  end

  def revise_associations
    if not is_reverting?
      self.recipe_ingredients.each(&:revise!)
      self.steps.each(&:revise!)
    end
  end

  def clear_draft_flag
    Recipe.draft_clear(self.created_by_id)
  end

  def set_tmp_link(ri)
    ri.edited_by = self.created_by_id
  end



end
