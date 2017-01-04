class HomeController < ApplicationController
  def index
  end

  def new_home
    TestMail.test_email.deliver_now
  end
end
