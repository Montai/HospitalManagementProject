class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  validates :first_name, presence: true, length: { maximum: 15 }, format: { with: /\A[a-zA-Z]+\z/,
      message: "only allows letters" }
  validates :last_name, presence: true, length: { maximum: 15 }, format: { with: /\A[a-zA-Z]+\z/,
      message: "only allows letters" }

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
  has_many :images, as: :imageable
  has_many :notes

  def appointments
    res = self.patient_appointments if self.doctor?
    res = self.doctor_appointments if self.patient?
    res
  end

  def self.getalldoctors
    self.all.select('id, first_name').doctor
  end



end
