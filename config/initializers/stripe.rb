if Rails.env == 'production'
  Rails.configuration.stripe = {
    :publishable_key => ENV['STRIPE_PROD_PUBLISHABLE_KEY'],
    :secret_key      => ENV['STRIPE_PROD_SECRET_KEY']
  }
else
  Rails.configuration.stripe = {
    :publishable_key => ENV['STRIPE_DEV_PUBLISHABLE_KEY'],
    :secret_key      => ENV['STRIPE_DEV_SECRET_KEY']
  }
end

Stripe.api_key = Rails.configuration.stripe[:secret_key]
