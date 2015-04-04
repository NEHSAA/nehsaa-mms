namespace :nehsaa do

  desc 'Backup Database'
  task :db_backup, :stamp do |t, args|
    stamp = "remote-#{args[:stamp]}"
    on roles(:db) do
      within release_path do
        rake "db:backup[#{stamp}]"
      end
    end
  end

  desc 'Restore Database'
  task :db_restore, :stamp do |t, args|
    stamp = "remote-#{args[:stamp]}"
    on roles(:db) do
      within release_path do
        rake "db:restore[#{stamp}]"
      end
    end
  end

  desc 'Upload Database'
  task :db_upload do |t, args|
    info "Upload Database "
  end

end
