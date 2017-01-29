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
    if resource.sign_in_count == 1 && resource.paid == false

      if current_user.invited_by_id.nil?
        # signing up and not part of an account
        new_account_path
      else
        # got an invite
        add_user_to_account
        templates_path
      end
    else
      # reg user
      templates_path
    end
  end

  def company_name_stipper(name)
    name.gsub(/\s+/, "_")
  end

  private

  def email_count(sub_type)
    case sub_type
    when "birdy"
      Pricing.new(Pricing::BIRDY).get_email_count
    when "flock"
      Pricing.new(Pricing::FLOCK).get_email_count
    when "nest"
      Pricing.new(Pricing::NEST).get_email_count
    else
      #TODO bubble up an error
    end
  end

  def seat_count(sub_type)
    case sub_type
    when "birdy"
      Pricing.new(Pricing::BIRDY).get_seat_count
    when "flock"
      Pricing.new(Pricing::FLOCK).get_seat_count
    when "nest"
      Pricing.new(Pricing::NEST).get_seat_count
    else
      #TODO bubble up an error
    end
  end

  def add_user_to_account
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
