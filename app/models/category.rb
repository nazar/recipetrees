class Category < ActiveRecord::Base

  has_many_polymorphs :members, :from => [:recipes]

  acts_as_tree_on_steroids :family_level => 0, :order => 'name'

  named_scope :top, :conditions => 'parent_id is null'

  attr_accessor :hash_children

  after_save :clear_all_caches



  named_scope :root, :conditions => 'parent_id is null'
  named_scope :ordered, :order => 'categories.parent_id asc, categories.name asc'
  named_scope :by_name, :order => 'categories.name asc'

  named_scope :by_id_array, lambda{|ids|
    { :conditions => {:id => ids} }
  }


  #scoped methods

  class << self
    extend ActiveSupport::Memoizable

    def categories_with_member_count(recipe_scope = {})
      recipe_conditions = recipe_scope.blank? ? {} : recipe_scope.current_scoped_methods[:find]
      #
      scoped( {
        :select => 'categories.name, categories.id, categories.parent_id,  count(1) recipes_count',
        :joins => 'left join categories_members on categories.id = categories_members.category_id '+
                  'inner join recipes on categories_members.member_id = recipes.id and categories_members.member_type = \'Recipe\' and recipes.`revisable_is_current` = 1',
        :group => 'categories.name',
     }.merge(recipe_conditions) )
    end

    def select_from_filter(params)
      params.select{|a| a =~ /^c:/}
    end

    def get_ids_from_filter(params)
      params.collect{|x| x.match('^c:(\d+):')[1] }
    end

    def full_tree_hierarchy_hash(scope = nil)
      cats = scope.nil? ? Category.ordered : scope
      parents = {}
      returning({}) do |result|
        cats.each do |category|
          if category.parent_id.blank?
            result[category] = []
            parents[category.id] = category
          else
            result[parents[category.parent_id]] << category
          end
        end
      end
    end


    def sort_categories_hash(categories)
      first = categories.select{|c| c.first.display_order.to_i > 0}.sort{|a,b| a.first.display_order <=> b.first.display_order}
      second = categories.select{|c| c.first.display_order.to_i == 0}.sort{|a,b| a.first.name <=> b.first.name }
      return first + second
    end

    def top_level_hash
      returning({}) do |result|
        Category.root.each{ |cat| result[cat.id] = cat }
      end
    end
    memoize :top_level_hash

    def clear_caches
      flush_cache(:top_level_hash)
    end


  end



  #instance methods

  def has_children?
    children_count > 0
  end

  def to_filter_s
    "c:#{id}:#{name.humanize}"
  end



  private

  def clear_all_caches
    Category.clear_caches
  end



end
