class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  after_create :send_welcome_email
  enum role: [:patient, :doctor]
  #Regex Variable Declaration
  NAME_REGEX = /\A[^0-9`!@#\$%\^&*+_=]+\z/
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  #Model Associations
  has_many :patient_appointments, class_name: "Appointment", foreign_key: :doctor_id, dependent: :destroy do
    def future
      where('status = :pending OR status = :cancelled', pending: Appointment.statuses[:pending], cancelled: Appointment.statuses[:cancelled]).order('date ASC')
    end
    def past
      where('status <> :pending', pending: Appointment.statuses[:pending]).order("date ASC")
    end
  end

  has_many :doctor_appointments, class_name: "Appointment", foreign_key: :patient_id, dependent: :destroy do
    def future
      where('status = :pending OR status = :cancelled', pending: Appointment.statuses[:pending], cancelled: Appointment.statuses[:cancelled]).order('date ASC')
    end
    def past
      where('status <> :pending', pending: Appointment.statuses[:pending]).order("date ASC")
    end
  end

  has_many :notes, dependent: :destroy

  #Model Validations
  validates :first_name,
            presence: true,
            length: { minimum: 2, maximum: 15 },
            format: { with: NAME_REGEX, message: 'only letters are allowed' }
  validates :last_name,
            presence: true,
            length: { minimum: 2, maximum: 15 },
            format: { with: NAME_REGEX, message: 'only letters are allowed' }
  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: EMAIL_REGEX, message: 'Check e-mail format(abc123@example.com)' }
  validates :password,
            presence: true,
            length: { minimum: 6, maximum: 20 }
  validates_confirmation_of :password
  validate :image_size_validation
  validate :validate_birth_date
  mount_uploader :image, ImageUploader
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :async, :omniauthable, omniauth_providers: [:facebook, :google_oauth2, :twitter]
  #Get the doctor list
  scope :get_all_doctors, -> { (select('id, first_name').where('role = :user_role', user_role: User.roles[:doctor])) }
  #Instance methods
  def future_appointments
    result = patient_appointments.future.includes(:patient) if doctor?
    result = doctor_appointments.future.includes(:doctor) if patient?
    result
  end

  def past_appointments
    result = patient_appointments.past.includes(:patient) if doctor?
    result = doctor_appointments.past.includes(:doctor) if patient?
    result
  end

  #Class Methods
  class << self
    def new_with_session(params, session)
      super.tap do |user|
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
        end
      end
    end

    def from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.name = auth.info.name
        user.image = auth.info.image
      end
    end

    def from_omniauth(access_token)
      data = access_token.info
      user = User.where(email: data['email']).first
      # users to be created if they don't exist
      unless user
        user = User.create(name: data['name'], email: data['email'], password: Devise.friendly_token[0,20])
      end
      user
    end
  end

  private
    #Send a welcome mail upon user signup
    def send_welcome_email
      UserMailer.welcome_email(self).deliver_now
    end

    def image_size_validation
      errors.add(:image, "should be less than 1 MB") if image.size > 1.megabytes
    end

    def validate_birth_date
      errors.add(:date_of_birth, "you must be 18 years or above") if date_of_birth > Time.now - 18.years
    end
end
