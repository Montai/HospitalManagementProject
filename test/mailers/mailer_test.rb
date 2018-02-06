require 'test_helper'

class MailerTest < ActionMailer::TestCase
  test "user_mailer" do
    mail = Mailer.user_mailer
    assert_equal "User mailer", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "signup_confirmation" do
    mail = Mailer.signup_confirmation
    assert_equal "Signup confirmation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
