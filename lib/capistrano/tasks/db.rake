namespace :deploy do
  namespace :db do

    desc 'Upload Database'
    task :upload do
      system 'bin/rake', 'db:data:dump'
      on roles(:app) do
        upload! 'db/data.yml', File.join(release_path, 'db/data.yml')
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, 'db:data:load'
          end
        end
      end
    end

    desc 'Initialize config/database.yml'
    task :init_config_yml do
      on roles(:app) do
        if test("[ ! -f #{shared_path}/config/database.yml ]")
          upload! 'config/database.yml', File.join(shared_path, 'config/database.yml')
        end
      end
    end

    desc 'Edit config/database.yml'
    task :edit_config, :server_index do |t, args|
      args.with_defaults(server_index: 0)
      server_index = args[:server_index].to_i
      on roles(:app)[server_index] do |server|
        cmd = ssh_cmd(server, ['vim', File.join(shared_path, 'config/database.yml')])
        info "[nehsaa:console] exec #{cmd.map{|s| %Q{#{s}} }.join(' ')}"
        exec *cmd
      end
    end

    before 'deploy:check:linked_files', 'deploy:db:init_config_yml'

  end
end
