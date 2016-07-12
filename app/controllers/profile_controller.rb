class ProfileController < ApplicationController
  def index
    @profile = User.find(current_user)
  end
end
