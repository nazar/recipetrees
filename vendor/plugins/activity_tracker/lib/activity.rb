class Activity < ActiveRecord::Base

  belongs_to :user
  belongs_to :item, :polymorphic => true
  validates_presence_of :user_id
  
  after_save :update_counter_on_user
  
  named_scope :of_item_type, lambda {|type|
    {:conditions => ["activities.item_type = ?", type]}
  }
  named_scope :of_item_types, lambda {|types|
    {:conditions => ["activities.item_type in (?)", types]}
  }
  named_scope :since, lambda { |time|
    {:conditions => ["activities.created_at > ?", time] }
  }
  named_scope :before, lambda {|time|
    {:conditions => ["activities.created_at < ?", time] }    
  }
  named_scope :recent, :order => "activities.created_at DESC"
  named_scope :by_users, lambda {|user_ids|
    {:conditions => ['activities.user_id in (?)', user_ids]}
  }
  
  
  def self.by(user)
    Activity.count('1', :conditions => ["activities.user_id = ?", user.id])
  end

  def update_counter_on_user
    if user_id.to_i > 0
      sql = "update users set activities_count = activities_count +1 where users.id = #{user_id}"
      ActiveRecord::Base.connection.execute(sql)
    end
  end
  
  def can_be_deleted_by?(user)
    return false if user.nil?
    return false unless user.admin? || user.moderator? || self.user_id.eql?(user.id)
    true
  end
    
end
