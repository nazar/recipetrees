class Blog < ActiveRecord::Base

  belongs_to :user

  acts_as_activity

  validates_presence_of :title, :body


  named_scope :by_date, :order => 'blogs.created_at DESC'

  named_scope :latest, lambda{|count|
    {:limit => count}
  }


  #instance methods

  def my_blog(current_user)
    current_user && (current_user.id == user_id)
  end

  def to_param
    "#{id}_#{title.to_permalink}"
  end

  def name
    title
  end

  def description
    body
  end

  def hit_views!(current_user)
    if not my_blog(current_user)
      Blog.increment_counter(:views_count, self.id)
    end
  end


end
