class CookingMethod < ActiveRecord::Base

  has_many :recipes

  validates_presence_of :name
  validates_uniqueness_of :name



  named_scope :by_name, :order => 'name asc'

end
