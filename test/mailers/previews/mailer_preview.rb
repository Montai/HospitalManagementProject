# Preview all emails at http://localhost:3000/rails/mailers/mailer
class MailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/mailer/user_mailer
  def user_mailer
    Mailer.user_mailer
  end

  # Preview this email at http://localhost:3000/rails/mailers/mailer/signup_confirmation
  def signup_confirmation
    Mailer.signup_confirmation
  end

end
