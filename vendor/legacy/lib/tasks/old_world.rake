namespace :old_world do

  desc "Download Old World Database Dump File"
  task get: :environment do
    %x{heroku pgbackups:capture --expire --app nehsaa-mms}
    url = %x{heroku pgbackups:url --app nehsaa-mms}
    dump_path = File.join(Rails.root, 'db/backup/oldworld-latest.dump')
    system('curl', '-o', dump_path, url)
  end

  desc "Reset Old World Database"
  task reset: :environment do
    dump_path = File.join(Rails.root, 'db/backup/oldworld-latest.dump')
    Rake::Task['old_world:get'].invoke unless File.exists? dump_path
    cmd = %w{pg_restore --verbose --clean --no-acl --no-owner}
    cmd += %w{-d nehsaa-mms/oldworld}
    cmd << dump_path
    conf = Rails.configuration.database_configuration['old_world']
    cmd += ['-h', conf['host'].to_s] if conf['host'].present?
    cmd += ['-p', conf['port'].to_s] if conf['port'].present?
    cmd += ['-U', conf['username'].to_s] if conf['username'].present?
    system(*cmd)
  end

  desc "Transfer Database from Old World to Current"
  task transfer: :environment do
    migrator = OldWorld::Migrator.new
    migrator.run
  end

  desc "Reset All"
  task :all do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['old_world:reset'].invoke
    Rake::Task['old_world:transfer'].invoke
  end

end
