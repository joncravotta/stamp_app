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
    :plan => parameters[:stripePlanType]
  )

  # TODO need to make an account here or earlier, prob should use a react component to get the
  # team account name
  @user = User.find(current_user.id)

  @account = Account.find(@user.account_id)


  @account.update(
    created_by: @user.email,
    seat_count: seat_count(charge.plan.id),
    email_count: email_count(charge.plan.id),
    stripe_plan_id: customer.id,
    stripe_current_period_start: charge.current_period_start,
    stripe_current_period_end: charge.current_period_end,
    stripe_sub_type: charge.plan.id
  )

  @account.save

  if @user
    @user.admin = true
    @user.paid = true
    @user.account_id = @account.id
    @user.save
    redirect_to slice_tool_path
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
    params.permit(:stripeEmail, :stripeToken, :stripePlanType, :teamName)
  end

end
