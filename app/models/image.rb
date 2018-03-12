class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true
  validate :validate_image
  # validates_presence_of :image, :message => "Please add image"
  mount_uploader :image, ImageUploader

  def validate_image
    self.errors.add(:image, 'can not be empty') and return if self.image.blank?
  end
end
