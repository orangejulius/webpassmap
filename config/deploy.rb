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
