class RecipeByOthers < ActiveRecord::Base

  belongs_to :user
  belongs_to :recipe

  has_many :images, :as => :imageable


  acts_as_activity

  after_create :log_to_feed


  named_scope :latest, :order => 'created_at DESC'





  private

  def log_to_feed
    create_action_user_activity('created', current_user)
  end

end
