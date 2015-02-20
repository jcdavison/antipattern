STRIPE_API_KEY = ENV['STRIPE_DEV_SECRET'] if Rails.env.development?
Stripe.api_key = STRIPE_API_KEY
