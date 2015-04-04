# config valid only for Capistrano 3.1
lock '3.3.5'

set :application, 'nehsaa-mms'
set :repo_url, 'https://github.com/NEHSAA/nehsaa-mms.git'

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
#set :deploy_to, '/srv/http/apps/nehsaa-mms'

# Default value for :scm is :git
set :scm, :git
set :git_strategy, Capistrano::Git::RailsStrategy

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml
                     }

# Default value for linked_dirs is []
set :linked_dirs, %w{bin
                     log
                     tmp/pids
                     tmp/cache
                     tmp/sockets
                     vendor/bundle
                     public/system
                     db/backup}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
#set :keep_releases, 5

# RVM specific configuration
# set :rvm_type, :system  # Defaults to: :auto (user, system, auto)
set :rvm_ruby_version, '2.2.0@nehsaa' # Defaults to: 'default'
# set :rvm_custom_path, '/opt/bitnami/rvm'  # only needed if not detected

# Puma specific configuration
#set :puma_bind, ["unix://#{ shared_path }/tmp/sockets/puma.sock",
#                 "tcp://127.0.0.1:9292"]

# Bundler specific configuration
#set :bundle_path, nil
#set :bundle_flags, '--system --quiet'
set :bundle_env_variables, { nokogiri_use_system_libraries: 1 }

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :mkdir, '-p', 'tmp'
        execute :touch, 'tmp/restart.txt'
      end
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      #within release_path do
      #  execute :rake, 'cache:clear'
      #end
    end
  end

end
