require 'capistrano/git'

module Capistrano::Git::RailsStrategy
  include Capistrano::Git::DefaultStrategy

  def release
    super
    release_git_path = File.join(release_path, '.git')
    unless context.test("[ -d #{release_git_path} ]")
      context.execute :cp, "-r", repo_path, release_git_path
    end
  end

end
