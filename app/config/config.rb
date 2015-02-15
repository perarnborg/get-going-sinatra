# Use Rack::Deflater to gzip assets
use Rack::Deflater

# Loads up all helpers in path
Dir.glob("./app/lib/*.rb").each {|r|
  require r
}

# Loads up all models in path
Dir.glob("./app/models/*.rb").each {|r|
  require r
}

# Loads up all controllers in path
Dir.glob("./app/controllers/*.rb").each {|r|
  require r
}

# Setup DB
ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  './app/db/development.sqlite3.db'
)

after do
  ActiveRecord::Base.clear_active_connections!
end

configure do

  set :public_folder, "assets"
  set :views, ["views"]
  set(:show_debuginfo) { false }
  enable :sessions
#  enable :cross_origin

end

# Setup Warden authentication
use Warden::Manager do |config|
  # Tell Warden how to save our User info into a session.
  # Sessions can only take strings, not Ruby code, we'll store
  # the User's `id`
  config.serialize_into_session{|user| user.id }
  # Now tell Warden how to take what we've stored in the session
  # and get a User from that information.
  config.serialize_from_session{|id| User.find(id) }
  # Default strategy
  config.default_strategies :oauth
  # When a user tries to log in and cannot, this specifies the
  # app to send the user to.
  config.failure_app = self
end

Warden::Strategies.add(:oauth) do
  def valid?
    params['access_token']
  end

  def authenticate!
    user = User.where(:access_token => params['access_token']).first

    if user.nil?
      fail!("The user could not be authenticated.")
    else
      success!(user)
    end
  end
end

Warden::Manager.before_failure do |env,opts|
  env['REQUEST_METHOD'] = 'GET'
end
