class TestMail < ApplicationMailer

  default from: 'notifications@pigeonpost.com'

  def test_email
    @url  = 'http://example.com/login'
    mail(to: 'test@gmail.com', subject: 'Hello this is a test')
  end
end
