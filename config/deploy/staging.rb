set :branch, 'staging'
set :rails_env, 'staging'

server '', user: 'poweruser', roles: %w(web db app)
