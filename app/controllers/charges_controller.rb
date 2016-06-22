class ChargesController < ApplicationController
before_filter :require_user
def new
end

def create
  customer = Stripe::Customer.create(
    :email => params[:stripeEmail],
    :source  => params[:stripeToken],
    :plan => params[:plan_type]
  )

  @user = User.find(current_user)

  if @user
    @user.stripe_customer_id = customer.id
    @user.stripe_current_period_start = customer.subscriptions.data[0].current_period_start
    @user.stripe_current_period_end = customer.subscriptions.data[0].current_period_end
    @user.stripe_plan_id = customer.subscriptions.data[0].id
    @user.email_code_count = email_count(params[:plan_type])
    @user.subscription_type = params[:plan_type]
    @user.paid = true
    @user.save
  else
    flash[:error] = 'Must be logged in'
    redirect_to root_path
  end

rescue Stripe::CardError => e
  flash[:error] = e.message
  redirect_to new_charge_path
end

  private

  def email_count(plan_type)
    case plan_type
    when 'SUB_199'
      50
    when 'SUB_299'
      125
    when 'SUB_399'
      100000000
    end
  end
end
