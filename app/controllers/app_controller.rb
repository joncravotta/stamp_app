class AppController < ApplicationController
  before_action :require_user, :require_paid
  def index
  end

  #create controller that can take in params so we can send it to the react comnponent
end
