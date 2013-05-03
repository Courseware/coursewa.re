Rails.configuration.stripe = {
  :public_key => ENV['PUBLIc_KEY'] || 'pk_test_czwzkTp2tactuLOEOqbMTRzG',
  :secret_key      => ENV['SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
