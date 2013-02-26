class Rating < ActiveRecord::Base

  belongs_to :rateable, :polymorphic => true
  belongs_to :user

  named_scope :by_object, lambda{|obj|
    {:conditions => ['rateable_id = ? and rateable_type = ?', obj.id, obj.class.to_s.constantize.base_class.to_s]}
  }

  named_scope :by_user, lambda{|user|
    {:conditions => ['user_id = ?', user.id], :order => 'created_at DESC'}
  }

  #class methods
  
  # Helper class method to look up a rateable object
  # given the rateable class name and id 
  def self.find_rateable(rateable_str, rateable_id)
    rateable_str.constantize.find(rateable_id)
  end

  def self.already_voted(rateable, ip, current_user)
    if current_user.blank?
      result = Rating.count('1', :conditions => ['rateable_id = ? and rateable_type = ? and ip = ?',
                            rateable.id, rateable.class.name, ip]) > 0
    else
      result = Rating.count('1', :conditions => ['rateable_id = ? and rateable_type = ? and user_id = ?',
                            rateable.id, rateable.class.name, current_user.id]) > 0
    end
    result
  end


  #instance methods

  def rateable_type=(sType)
    super(sType.constantize.base_class.name)
  end

end