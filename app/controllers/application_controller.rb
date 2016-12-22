class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def logged_in?
    # !! returns true or false
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:danger] = "You must be logged in to perform that action"
      redirect_to root_path
    end
  end

  def require_paid
    @user = User.find(current_user)
    if !@user.paid?
      flash[:danger] = "Your payment has failed, please update your card on file."
      redirect_to new_charge_path
    end
  end

  def after_sign_in_path_for(resource)
    if resource.sign_in_count == 1
      new_charge_path
    else
      root_path
    end
  end

  def email_count(plan_type)
    case plan_type
    when 'SUB_199'
      100
    when 'SUB_299'
      225
    when 'SUB_399'
      400
    end
  end
end
