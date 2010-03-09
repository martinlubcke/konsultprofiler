# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_konsultprofiler_session',
  :secret      => '73aedbfc240ddb86eb915e4dd6a7d142651cae2446dfc4d64e854eed2ad8b92f4ba0ec31cf7b08951fe10cb8f8f59b444b1dfcc535cb2175f12eae83a4df0201'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
