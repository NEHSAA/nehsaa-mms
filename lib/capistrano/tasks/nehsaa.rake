namespace :nehsaa do

  desc 'Generate Certificate Key & Request (Overwrite)'
  task :gen_cert do
    on roles(:app) do
      within '/opt/bitnami/apache2/conf' do
        execute :sudo, '/opt/bitnami/common/bin/openssl', 'genrsa',
                '-out', 'server.key', 2048
        execute :sudo, '/opt/bitnami/common/bin/openssl', 'req',
                '-key', 'server.key', '-out', 'cert.csr'
      end
    end
  end

  desc 'Generate Temporary Certificate (Overwrite)'
  task :gen_temp_certificate do
    on roles(:app) do
      within '/opt/bitnami/apache2/conf' do
        execute :sudo, '/opt/bitnami/common/bin/openssl', 'x509',
                '-in', 'cert.csr', '-out', 'server.crt', '-req',
                '-signkey', 'server.key', '-days', '365'
      end
    end
  end

  desc 'Restart Apache Daemon'
  task :restart_httpd do
    on roles(:app) do
      execute :sudo, '/opt/bitnami/ctlscript.sh', 'restart', 'apache'
    end
  end

end
