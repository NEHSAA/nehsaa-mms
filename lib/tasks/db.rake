namespace :db do

  desc 'Backup Database'
  task :backup, [:stamp] => :environment do |t, args|
    output_file = "db/backup/#{Rails.env}-#{args[:stamp]}.sql"
    conf = Rails.configuration.database_configuration[Rails.env]
    cmd = %w(pg_dump -Fc --no-acl --no-owner)
    cmd += ['-h', conf['host'].to_s] if conf['host'].present?
    cmd += ['-p', conf['port'].to_s] if conf['port'].present?
    cmd += ['-U', conf['username'].to_s] if conf['username'].present?
    cmd += ['-f', output_file]
    cmd << conf['database']
    system *cmd
  end

  desc 'Restore Database'
  task :restore, [:stamp] => :environment do |t, args|
    input_file = "db/backup/#{Rails.env}-#{args[:stamp]}.sql"
    conf = Rails.configuration.database_configuration[Rails.env]
    cmd = %w(pg_restore -Fc --no-acl --no-owner --clean)
    cmd += ['-h', conf['host'].to_s] if conf['host'].present?
    cmd += ['-p', conf['port'].to_s] if conf['port'].present?
    cmd += ['-U', conf['username'].to_s] if conf['username'].present?
    cmd += ['-d', conf['database']]
    cmd << input_file
    system *cmd
  end

end
