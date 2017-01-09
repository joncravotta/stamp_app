require 'byebug'
class ChargesController < ApplicationController
before_filter :require_user
def new
end

def create
  parameters = sub_params

  customer = Stripe::Customer.create(
    :email => parameters[:stripeEmail],
    :source  => parameters[:stripeToken],
    :plan => parameters[:stripePlanType]
  )


  charge = Stripe::Subscription.create(
    :customer => customer.id,
    :plan => parameters[:stripePlanType],
  )

  @user = User.find(current_user.id)

  if @user
    puts customer
    puts charge
    @user.stripe_customer_id = customer.id
    @user.stripe_current_period_start = charge.current_period_start
    @user.stripe_current_period_end = charge.current_period_end
    @user.stripe_plan_id = charge.id
    @user.email_code_count = email_count(charge.plan.id)
    @user.subscription_type = charge.plan.id
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

  def sub_params
    params.permit(:stripeEmail, :stripeToken, :stripePlanType)
  end

end
