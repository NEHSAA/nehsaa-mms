namespace :user do

  desc 'List all users'
  task :list => :environment do
    puts "List all users (count = #{User.count})"
    User.all.each do |user|
      puts "(#{user.id}) #{user.login}"
    end
  end

  desc 'Add a new user'
  task :add, [:name, :email] => :environment do |t, args|
    puts "Add a new user"
    unless User.exists? login: args[:name]
      User.create login: args[:name],
                  email: args[:email],
                  password: ask("Password:"){|q| q.echo = false },
                  password_confirmation: ask("Confirm Password:"){|q| q.echo = false }
      puts "User #{args[:name]} is added."
    else
      puts "User #{args[:name]} already exists"
    end
  end

  desc 'Remove a user'
  task :remove, [:name] => :environment do |t, args|
    User.destroy User.find_by_login(args[:name])
    puts "User #{args[:name]} is removed."
  end

  desc 'Change password of a user'
  task :change_password, [:name] => :environment do |t, args|
    if User.exists? login: args[:name]
      User.update User.find_by_login(args[:name]),
                  password: ask("Password:"){|q| q.echo = false },
                  password_confirmation: ask("Confirm Password:"){|q| q.echo = false }
    end
  end

end
