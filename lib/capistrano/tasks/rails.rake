namespace :rails do

  desc 'Start a rails console'
  task :console, [:server_index] => ['deploy:set_rails_env'] do |t, args|
    args.with_defaults(server_index: 0)
    server_index = args[:server_index].to_i
    on roles(:app)[server_index] do |server|
      cmd = ssh_cmd(server, ['cd', release_path, '&&',
                             SSHKit.config.command_map[:bundle], 'exec',
                             'script/rails', 'c', fetch(:rails_env)])
      info "[rails:console] exec #{cmd.map{|s| %Q{#{s}} }.join(' ')}"
      exec *cmd
    end
  end

end
