class Step < ActiveRecord::Base

  belongs_to :recipe, :counter_cache => :steps_count


  validates_presence_of :step_no, :time_required, :description,
                        :if => Proc.new { |step| not Recipe.draft(step.edited_by || step.recipe.created_by_id) }

  before_validation :time_required_to_seconds   #before validate as we need it before the parent is saved

  StagePreparation  = 1
  StageCooking      = 2
  StageFinishing    = 3


  has_attached_file :image,
                    :styles => { :original => ['350x250#', 'jpg'], :thumbnail => ['90x90#', 'jpg']  },
                    :default_style => :original,
                    :convert_options => { :all => "-strip" }

  acts_as_revisable

  attr_accessor :edited_by

  #class methods

  def self.stages
    {Step::StagePreparation => 'preparation', Step::StageCooking => 'cooking', Step::StageFinishing => 'presentation'}
  end

  #instance methods

  def step_actual
    step_no
  end

  def step_actual=(value)
    self.step_no = value
  end

  def cloneable_attributes
    to_clone = ['step_no', 'time_required', 'time_required_seconds', 'description']
    out = attributes.inject({}) do |result, attribute|
      result.merge( to_clone.include?(attribute.first) ? {attribute.first => attribute.last} : {} )
    end
    #finally add previous id
    out.merge(:cloned_from_id => self.id)
  end

  private

  def time_required_to_seconds
    time = 0
    unless time_required.blank?
      time_required.match(/(\d+)\s*d/i)    ? time += $1.to_i * 24 * 60 * 60 : ''
      time_required.match(/(\d+)\s*h/i)    ? time += $1.to_i      * 60 * 60 : ''
      time_required.match(/(\d+)\s*m/i)    ? time += $1.to_i           * 60 : ''
      time_required.match(/^(\d+)$/)       ? time += $1.to_i           * 60 : ''
      time_required.match(/(\d+)\s*s/i)    ? time += $1.to_i                : ''
      #
      self.time_required_seconds = time
    end
  end


end
