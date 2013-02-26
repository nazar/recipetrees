class Cuisine < ActiveRecord::Base

  has_many :recipes

  validates_presence_of :name
  validates_uniqueness_of :name


  named_scope :by_name, :order => 'name asc'

  #scoped class methods

  def self.cuisines_with_recipes_count(recipe_scope = {})
    recipe_conditions = recipe_scope.blank? ? {} : recipe_scope.current_scoped_methods[:find]
    #
    scoped( {
      :select => 'cuisines.id, cuisines.name, count(1) recipes_count',
      :joins => 'inner join recipes on recipes.cuisine_id = cuisines.id and recipes.revisable_is_current = 1',
      :group => 'cuisines.name'
   }.merge(recipe_conditions) )
  end

  #class methods

  def self.select_from_filter(params)
    params.select{|a| a =~ /^q:/}
  end

  def self.get_ids_from_filter(params)
    params.collect{|x| x.match('^q:(\d+):')[1] }
  end



  #instance methods

  def to_filter_s
    "q:#{id}:#{name.humanize}"
  end


end
