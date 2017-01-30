require 'json'
require 'stripe'

class WebhookController < ApplicationController
  protect_from_forgery :except => :stripe

  #CHARGE_FAILED = 'charge.failed'
  #CHARGE_SUCCEEDED = 'charge.succeeded'
  INVOICE_SUCCEEDED = 'invoice.payment_succeeded'
  INVOICE_FAILED = 'invoice.payment_failed'
  CUSTOMER_SUBSCRIPTION_UPDATED = 'customer.subscription.updated'

  def test_stripe_event
    event = Stripe::Event.retrieve('evt_19SFdNAbdjxMHYRyVF0MBvWD')
  end

  def cancel_subscription
  end

  def stripe
    # should prob just get the event id and make a request on our own, once we make request we can feel
    # feel safe about the data we are receiving
    event_json = JSON.parse(request.body.read)
    # Verify the event by fetching it from Stripe
    event = Stripe::Event.retrieve(event_json["id"])

    case event.type
    when INVOICE_FAILED
      update_customer_inactive(data)
    when INVOICE_SUCCEEDED
      update_customer_active(event)
    when CUSTOMER_SUBSCRIPTION_UPDATED
      update_customer_subscription(event)
    end
  end

  def cancel_membership
    # post to cancel a user membership
  end

  private

  def update_customer_active(event)
    # serach by stripe customer id
    object = event.data.object
    @user = User.find(object.customer)
    if @user
      @user.subscription_status = "authorized"
      @user.stripe_plan_id = object.subscription #"sub_9lnD5e3zjbOmex"?
      @user.save
    end
  end

  # only used when a customer changes plan
  def update_customer_subscription(event)
    object = event.data.object
    @user = User.find(object.customer)
    if @user
      @user.subscription_status = "authorized"
      @user.stripe_plan_id = object.plan.id
      @user.current_period_start = object.current_period_start
      @user.current_period_end = object.current_period_end
      @user.email_code_count = email_count(object.plan.id)
    end
  end

  def update_customer_inactive(data)
    # serach by stripe customer id
    @user = User.find(data['data']['object']['customer'])
    if @user
      @user.subscription_status = "unauthorized"
    end
  end
end
