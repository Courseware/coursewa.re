Rails.configuration.stripe = {
  :public_key => ENV['PUBLIC_KEY'],
  :secret_key => ENV['SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
