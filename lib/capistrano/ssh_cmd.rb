def ssh_cmd(server, cmd_array, options = {})
  ssh_options = server.ssh_options
  auth_method = ssh_options[:auth_methods].first
  cmd = %w(ssh)
  cmd += ['-l', ssh_options[:user] || server.user]
  if options[:tunnel]
    client_port, remote_port = options[:tunnel]
    cmd += ['-N', '-L', "#{client_port}:127.0.0.1:#{remote_port}"]
  else
    cmd += ['-p', ssh_options[:port] || server.port || '22']
    cmd << '-t'
  end
  if auth_method == 'publickey'
    Array(ssh_options[:keys]).each do |key|
      cmd += ['-i', key]
    end
  end
  cmd << server.hostname
  cmd << cmd_array.map{|s| %Q{#{s}} }.join(' ')
  cmd
end
