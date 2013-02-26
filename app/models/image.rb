class Image < ActiveRecord::Base

  belongs_to :imageable, :polymorphic => true

  belongs_to :user

  after_create  :update_object_images_count
  after_destroy :update_object_images_count

  has_attached_file :picture,
                    :styles => { :original => ['350x250#', 'jpg'], :thumbnail => ['75x75#', 'jpg']  },
                    :default_style => :original,
                    :convert_options => { :all => "-strip" }

  #class methods


  #instance methods


  protected

  def update_object_images_count
    if imageable.respond_to?('images_count')
      imageable.images_count = imageable.images.count
      imageable.save
    end
  end



end
