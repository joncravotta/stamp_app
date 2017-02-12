require 'json'
require 'stripe'

class WebhookController < ApplicationController
  protect_from_forgery :except => :stripe


  #CHARGE_SUCCEEDED = 'charge.succeeded'
  INVOICE_SUCCEEDED = 'invoice.payment_succeeded'
  INVOICE_FAILED = 'invoice.payment_failed'
  CHARGE_FAILED = 'charge.failed'
  CUSTOMER_SUBSCRIPTION_UPDATED = 'customer.subscription.updated'

  def test_stripe_event
    event = Stripe::Event.retrieve('evt_19SFdNAbdjxMHYRyVF0MBvWD')
  end

  def stripe
    # should prob just get the event id and make a request on our own, once we make request we can feel
    # feel safe about the data we are receiving
    event_json = JSON.parse(request.body.read)
    # Verify the event by fetching it from Stripe
    event = Stripe::Event.retrieve(event_json["id"])

    case event.type
    when INVOICE_FAILED || CHARGE_FAILED
      update_customer_inactive(data)
    when INVOICE_SUCCEEDED
      update_customer_active(event)
    when CUSTOMER_SUBSCRIPTION_UPDATED
      update_customer_subscription(event)
    else
      puts "LOG: event sent but not used - #{event.type}"
    end
  end

  def cancel_membership
    # TODO post to cancel a user membership
  end

  private

  # we get this when we know a customer has paid
  def update_customer_active(event)
    object = event.data.object
    @account = Account.where(stripe_plan_id: object.customer).first

    @account.update(
      stripe_current_period_start: object.period_start,
      stripe_current_period_end:   object.period_end,
      stripe_sub_type:             object.subscription,
      is_valid:                    true
    )
    @account.save
  end

  # used when a customer changes plan
  def update_customer_subscription(event)
    object = event.data.object
    @account = Account.where(stripe_plan_id: object.customer)

    @account.update(
      stripe_current_period_start: object.period_start,
      stripe_current_period_end:   object.period_end,
      stripe_sub_type:             object.subscription,
      email_count:                 email_count(object.plan.id),
      is_valid:                    true
    )

    @account.save
  end

  def update_customer_inactive(event)
    object = event.data.object
    @account = Account.find(stripe_plan_id: object.customer)

    @account.update(
        @account.is_valid = false
    )

    @account.save
    # TODO send email to notify team
  end
end
