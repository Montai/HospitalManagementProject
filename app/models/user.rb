class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  validates :first_name, presence: true, length: { maximum: 15 }, format: { with: /\A[a-zA-Z]+\z/,
      message: "only allows letters" }
  validates :last_name, presence: true, length: { maximum: 15 }, format: { with: /\A[a-zA-Z]+\z/,
      message: "only allows letters" }
  enum role: {
    patient: 0,
    doctor: 1
  }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :patient_appointments, class_name: "Appointment", foreign_key: :patient_id, dependent: :destroy
  has_many :doctor_appointments, class_name: "Appointment", foreign_key: :doctor_id, dependent: :destroy
  has_many :images, as: :imageable

end
