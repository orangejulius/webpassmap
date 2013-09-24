require 'bundler/capistrano'
require 'rvm/capistrano'
require 'capistrano-unicorn'

set :application, "webpassmap"
set :repository,  "https://github.com/orangejulius/webpassmap.git"

role :app, "juliansimioni.com"
role :web, "juliansimioni.com"
role :db,  "juliansimioni.com"

set :user, 'webpassmap'
set :deploy_to, '/home/webpassmap'
set :use_sudo, false

after 'deploy:restart', 'unicorn:restart'  # app preloaded
after  'deploy:finalize_update', 'config:symlink'

namespace :config do
  desc "Symlink the configuration files for the app"
  task :symlink do
    run <<-CMD
      for i in `ls -A #{shared_path}/config`; do
        if test -f "#{shared_path}/config/$i"; then
          ln -nfs "#{shared_path}/config/$i" "#{release_path}/config/$i";
        fi;
      done;
    CMD
  end
end
