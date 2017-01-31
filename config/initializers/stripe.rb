if Rails.env.production?
  Rails.configuration.stripe = {
    :publishable_key => ENV['PUBLISHABLE_KEY'],
    :secret_key      => ENV['SECRET_KEY']
  }

  Stripe.api_key = Rails.configuration.stripe[:secret_key]
else
  Rails.configuration.stripe = {
    :publishable_key => ENV['STRIPE_DEV_PUBLISHABLE_KEY'],
    :secret_key      => ENV['STRIPE_DEV_SECRET_KEY']
  }

  Stripe.api_key = Rails.configuration.stripe[:secret_key]
end
