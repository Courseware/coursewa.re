require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
# require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :codename, 'coursewa.re'

set :port, '8000'
set :user, 'deployer'
set :domain, 'lipsett.nerd.ro'
set :deploy_to, "/home/#{user}/#{codename}"
set :repository, 'git@github.com:stas/coursewa.re.git'
set :branch, 'master'

set :pid_file, "#{deploy_to}/shared/tmp/pids/#{rails_env}.pid"
set :app_port, '3001'
set :app_path, lambda { "#{deploy_to}/#{current_path}" }

# Manually create these paths in shared/
# (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'log', 'tmp']

# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use[ruby-1.9.3-p125@default]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/pids"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue!  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    to :prepare do
      invoke :stop unless ENV['SKIP_STOP']
    end

    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :launch do
      invoke :start unless ENV['SKIP_START']
    end
  end
end

desc 'Starts the application'
task :start => :environment do
  queue "cd #{app_path} ; bundle exec rackup -s puma " +
    "-p #{app_port} -P #{pid_file} -E #{rails_env} -D"
  queue "cd #{app_path} ; RAILS_ENV=#{rails_env} ./script/delayed_job start"
end

desc 'Stops the application'
task :stop => :environment do
  queue "cd #{app_path} ; RAILS_ENV=#{rails_env} ./script/delayed_job stop"
  queue %[kill -9 `cat #{pid_file}`]
end

desc 'Restarts the application'
task :restart => :environment do
  invoke :stop
  invoke :start
end

desc 'Installs dependent OS packages/libs along with latest rbenv'
task 'rbenv:prepare' do
  queue! 'echo "Make sure these are installed:"'
  queue! 'echo "git-core libxml2-dev libxslt1-dev libreadline-dev libssl-dev ' +
   'openssl zlib1g-dev zlib1g libyaml-dev build-essential libpq-dev"'

  queue 'git clone git://github.com/sstephenson/rbenv.git ~/.rbenv'
  queue 'git clone git://github.com/sstephenson/ruby-build.git ' +
    '~/.rbenv/plugins/ruby-build'

  queue %[echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile]
  queue %[source ~/.bash_profile]
  queue %[echo 'eval "$(rbenv init -)"' >> ~/.bash_profile]
end

desc 'Uses rbenv-build to install ruby-1.9.3-p392'
task 'rbenv:install:1.9.3-p392' => :environment do
  invoke 'rbenv:prepare'
  queue 'rbenv install 1.9.3-p392'
  queue 'rbenv local 1.9.3-p392'
  queue 'gem install bundler'
  queue 'rbenv rehash'
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

