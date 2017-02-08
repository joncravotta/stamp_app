class ProfileController < ApplicationController
  def index
    @profile = User.find(current_user)
    @account = Account.find(@profile.account_id)
  end
end
