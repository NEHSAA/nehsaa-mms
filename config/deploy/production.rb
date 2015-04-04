set :stage, :production
set :rails_env, :production

set :server_name, 'nehsaa.bitnamiapp.com'

set :deploy_to, '/opt/bitnami/apps/nehsaa-mms'

set :rvm_type, :system
set :rvm_custom_path, '/opt/bitnami/rvm'

set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

# role :app, %w{deploy@example.com}
# role :web, %w{deploy@example.com}
# role :db,  %w{deploy@example.com}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

# server 'example.com', user: 'deploy', roles: %w{web app}, my_property: :my_value
server 'nehsaa.bitnamiapp.com', roles: %w{web app db},
       user: 'bitnami',
       ssh_options: {
         user: 'bitnami',
         forward_agent: true,
         auth_methods: %w(publickey),
         keys: "config/deploy/keys/bitnami-hosting.pem"
       }

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
