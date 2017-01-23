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
      redirect_to new_account_path
    end
  end

  def after_sign_in_path_for(resource)
    # TODO this is shitty af
    byebug
    if resource.sign_in_count == 1
      #if current_user.paid
      if current_user.invited_by_id.nil?
        new_account_path
      else
        add_user_to_account
        templates_path
      end

    else
      templates_path
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

  def seat_count(plan_type)
    case plan_type
    when 'SUB_199'
      1
    when 'SUB_299'
      3
    when 'SUB_399'
      5
    end
  end

  def company_name_stipper(name)
    name.gsub(/\s+/, "_")
  end

  private

  def add_user_to_account
    byebug
    @user = current_user
    @inviter = User.find(@user.invited_by_id)
    @account = Account.find(@inviter.account_id)

    if @account.seat_count > 0
      @account.seat_count = @account.seat_count - 1
      @account.save

      @user.account_id = @inviter.account_id
      @user.paid = true
      @user.save

      #TODO else clause
    end
  end
end
