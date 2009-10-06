# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_kitchen_session',
  :secret      => '2395a66a733fb1e1779c600c9ee553216049e41b0e6695736a6c672d4e5f19253773ab9649257d13760cacd0eff429393d842e7bc1d533e4689a9de067baf4ff'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
