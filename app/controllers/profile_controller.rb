class ProfileController < ApplicationController
  def index
    @profile = User.find(current_user)
    @account = Account.find(@profile.account_id)
    @sub_type = sub_type(@account.stripe_sub_type)
  end

  private

  def sub_type(sub)
    case sub
    when 'SUB_199'
      '50'
    when 'SUB_299'
      '125'
    when 'SUB_399'
      'unlimited'
    end
  end
end
