class RecipeFork < ActiveRecord::Base

  belongs_to :origin, :foreign_key => :from_recipe_id, :class_name => 'Recipe'
  belongs_to :fork,   :foreign_key => :to_recipe_id, :class_name => 'Recipe'
  belongs_to :forker, :foreign_key => :forked_by_id, :class_name => 'User'


  after_create :update_forks_count



  protected

  def update_forks_count
    Recipe.increment_counter(:forks_count, self.origin.id)
  end

end
