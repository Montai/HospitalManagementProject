class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  validates :first_name, 
            presence: true, 
            length: { minimun: 2, maximum: 15 }, 
            format: { with: /\A[a-zA-Z]+\z/, message: "only letters are allowed" }

  validates :last_name, 
            presence: true, 
            length: { minimum: 2, maximum: 15 }, 
            format: { with: /\A[a-zA-Z]+\z/, message: "only letters are allowed" }

  validates :email, 
            presence: true, 
            uniqueness: true, 
            format: { with: /\A(\S+)@(.+)\.(\S+)\z/, message: "Check e-mail format(abc123@example.com)" }

  validates :password, 
            presence: true, 
            length: { minimum: 6, maximum: 20 }

  validates_confirmation_of :password

  enum role: [:patient, :doctor]

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :patient_appointments, class_name: "Appointment", foreign_key: :doctor_id, dependent: :destroy do

    def future
      where("status = ? OR status = ?", 0, 2).order('created_at DESC')
    end

    def past
      where("status = ?", 1).order('created_at DESC')
    end

  end


  has_many :doctor_appointments, class_name: "Appointment", foreign_key: :patient_id, dependent: :destroy do

    def future
      where("status = ? OR status = ?", 0, 2).order('created_at DESC')
    end

    def past
      where("status = ?", 1).order('created_at DESC')
    end

  end

  has_many :visited_doctors, through: :doctor_appointments
  has_many :patients, through: :patient_appointments
  has_many :images, as: :imageable, dependent: :destroy
  has_many :notes, dependent: :destroy


  def future_appointments
    result = self.patient_appointments.future if self.doctor?
    result = self.doctor_appointments.future.includes(:doctor) if self.patient?
    result
  end

  def past_appointments
    result = self.patient_appointments.past if self.doctor?
    result = self.doctor_appointments.past.includes(:doctor) if self.patient?
    result
  end

  class << self

    def getalldoctors
      all.select('id, first_name').doctor
    end

  end

  # after_create :welcome_send

  # def welcome_send 
  #   UserMailer.signup_confirmation(self).deliver
  # end 

end
