class Measure < ActiveRecord::Base



  named_scope :by_name, :order => 'name asc'

  #instance methods

  def self.by_name_cache
    @measures ||= Measure.by_name
  end

end
