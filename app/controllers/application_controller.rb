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
      flash[:danger] = "You must buy a pass to pigeon post to access"
      redirect_to root_path
    end
  end
end
