class ProfileController < ApplicationController
  before_action :require_admin_user

  def index
    @profile = User.find(current_user)
    @account = Account.find(@profile.account_id)
  end
end
