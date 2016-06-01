Rails.configuration.stripe = {
  :publishable_key => 'pk_test_bxP1DpFnsvFCJnlDFzNVmsvo',
  :secret_key      => 'sk_test_bnDBQSBGkqHUJIRUR6U2OIAD'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
