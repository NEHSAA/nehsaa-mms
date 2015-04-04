namespace :console do

  desc 'Open SSH Shell of the remote server'
  task :open, :server_index do |t, args|
    args.with_defaults(server_index: 0)
    server_index = args[:server_index].to_i
    on roles(:app)[server_index] do |server|
      cmd = ssh_cmd(server, ['cd', deploy_path, ';', 'bash'])
      info "[nehsaa:console] exec #{cmd.map{|s| %Q{#{s}} }.join(' ')}"
      exec *cmd
    end
  end

  desc 'Open SSH Tunnel of the remote server'
  task :tunnel, :server_index do |t, args|
    args.with_defaults(server_index: 0)
    server_index = args[:server_index].to_i
    on roles(:app)[server_index] do |server|
      cmd = ssh_cmd(server, [], tunnel: [8888, 443])
      info "[nehsaa:tunnel] exec #{cmd.map{|s| %Q{#{s}} }.join(' ')}"
      exec *cmd
    end
  end

end

task :console => 'console:open'
task :tunnel => 'console:tunnel'
