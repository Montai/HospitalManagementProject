class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  enum role: [:patient, :doctor]

  validates :first_name, 
            presence: true, 
            length: { minimum: 2, maximum: 15 }, 
            format: { with: /\A[a-zA-Z]+\z/, message: 'only letters are allowed' }

  validates :last_name, 
            presence: true, 
            length: { minimum: 2, maximum: 15 }, 
            format: { with: /\A[a-zA-Z]+\z/, message: 'only letters are allowed' }

  validates :email, 
            presence: true, 
            uniqueness: true, 
            format: { with: /\A(\S+)@(.+)\.(\S+)\z/, message: 'Check e-mail format(abc123@example.com)' }

  validates :password, 
            presence: true, 
            length: { minimum: 6, maximum: 20 }

  validates_confirmation_of :password
  

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :patient_appointments, 
            class_name: "Appointment", 
            foreign_key: :doctor_id, dependent: :destroy do

    def future
      where('status = ? OR status = ?', Appointment.statuses[:pending], Appointment.statuses[:cancelled])
      .order('date ASC')
    end

    def past
      where('status <> ?', Appointment.statuses[:pending])
      .order("date ASC")  
    end

  end


  has_many :doctor_appointments, 
            class_name: "Appointment", 
            foreign_key: :patient_id, dependent: :destroy do

    def future
      where('status = ? OR status = ?', Appointment.statuses[:pending], Appointment.statuses[:cancelled])
      .order('date ASC')
    end

    def past
      where('status <> ?', Appointment.statuses[:pending])
      .order("date ASC")  
    end

  end

  has_many :notes, dependent: :destroy
  has_many :images, as: :imagable, dependent: :destroy


  def future_appointments
    result = self.patient_appointments.future.includes(:patient) if self.doctor?
    result = self.doctor_appointments.future.includes(:doctor) if self.patient?
    result
  end

  def past_appointments
    result = self.patient_appointments.past.includes(:patient) if self.doctor?
    result = self.doctor_appointments.past.includes(:doctor) if self.patient?
    result
  end 

  class << self

    def getalldoctors
      all.select('id, first_name').doctor
    end

  end

end
