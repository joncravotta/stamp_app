class ChargesController < ApplicationController
before_filter :require_user
def new
end

def create
  # Amount in cents
  @amount = 500
  @user = User.find(current_user)

  if @user
    @user.paid = true
    @user.save
  else
    flash[:error] = "Must be logged in"
    redirect_to root_path
  end


  customer = Stripe::Customer.create(
    :email => params[:stripeEmail],
    :source  => params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :customer    => customer.id,
    :amount      => @amount,
    :description => 'Rails Stripe customer',
    :currency    => 'usd'
  )

rescue Stripe::CardError => e
  flash[:error] = e.message
  redirect_to new_charge_path
end
end
