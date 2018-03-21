class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@hospital.com"
  layout 'mailer'
end
