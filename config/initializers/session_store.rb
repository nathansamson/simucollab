# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_simutrans-collab_session',
  :secret      => 'aa502322c1bdd4de994c3bdfa9cd1e787aadeb697d8ef66a4c691204078911fbbb2268cdcb6d921824c63d124106850d7970f59f3a1c6b5f2e94d2c3c0e9c21d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
