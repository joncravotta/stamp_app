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

  # we get this when we know a customer has paid
  def update_customer_active(event)
    # serach by stripe customer id
    object = event.data.object
    @user = User.find(object.customer)
    @account = Account.find(@user.account_id)

    if @account
      @account.subscription_status = "authorized"
      @account.stripe_sub_type = object.subscription #"sub_9lnD5e3zjbOmex"?
      @account.save
    end
  end

  # used when a customer changes plan
  def update_customer_subscription(event)
    object = event.data.object
    @user = User.find(object.customer)
    @account = Account.find(@user.account_id)

    if @account
      @account.subscription_status = "authorized"
      #TODO figure out how to update seat count and email count logic
      @account.stripe_sub_type = object.plan.id
      @account.stripe_current_period_start = object.current_period_start
      @account.stripe_current_period_end = object.current_period_end
      @account.email_count = email_count(object.plan.id)
    end
  end

  # TODO need to look into this more
  def update_customer_inactive(data)
    # serach by stripe customer id
    @user = User.find(data['data']['object']['customer'])
    if @user
      @user.subscription_status = "unauthorized"
    end
  end
end
