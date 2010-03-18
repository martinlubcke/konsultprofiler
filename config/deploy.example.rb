require "capistrano_database"

set :application, "konsultprofiler"
set :repository,  "/path to/konsultprofiler"

default_run_options[:pty] = true
set :repository,  "git@github.com:martinlubcke/konsultprofiler.git"
set :scm, :git
set :scm_passphrase, "xxx"
set :user, "xxx"
set :deploy_via, :remote_cache

role :web, "xxx"
role :app, "xxx"
role :db,  "xxx", :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end