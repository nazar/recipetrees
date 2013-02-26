class BloggerObserver < ActiveRecord::Observer

  observe Blog

  def after_create(blog)
    Achievement.transaction do
      BloggerBadge.award_achievements_for(blog.user)
      Reputation.process_reputation_for(blog)
    end
  end

end