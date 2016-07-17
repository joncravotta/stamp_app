class ProfileController < ApplicationController
  def index
    @profile = User.find(current_user)
    @sub_type = sub_type(@profile.subscription_type)
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
