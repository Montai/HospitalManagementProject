class Appointment < ActiveRecord::Base

  # attr_accessor :time_slot
  mount_uploader :image, ImageUploader

  enum status: [:pending, :unvisited, :cancelled, :visited]

  validates :date, presence: true
  validates :image, 
            presence: true, 
            format: { with: %r{\.(gif|jpg|png)\z}i, message: "must be gif,png or jpeg" }
  
  validate :validate_image
  validate :validate_appointment_date 

  belongs_to :patient, 
              class_name: "User", 
              foreign_key: 'patient_id'
              
  belongs_to :doctor, 
              class_name: "User", 
              foreign_key: 'doctor_id'

  has_many :notes, dependent: :destroy

  # has_many :images, as: :imagable, dependent: :destroy

  # accepts_nested_attributes_for :images, allow_destroy: true

  accepts_nested_attributes_for :notes, allow_destroy: true




  def validate_appointment_date
    self.errors.add(:date, "can not be left as blank") and return if self.date.blank?
  end

  def validate_image
    self.errors.add(:image, "can't be blank") and return if self.image.blank?
  end 


  class << self

    def closed_status
      where('status = ?', 'unvisited' ).order('date DESC')
    end

    def all_pending_appointments
      where('status = ?', 'pending')
    end

    def available_appointment_slots(curr_app_date)
      where('date = ? ',curr_app_date).pluck('starting_time')
    end    

  end

end
