# Set your full path to application.
app_path = "/home/webpassmap/current"

# Set unicorn options
worker_processes 1
preload_app true
timeout 180
listen "127.0.0.1:9000"

# Spawn unicorn master worker for user apps (group: apps)
user 'webpassmap', 'webpassmap'

# Fill path to your app
working_directory app_path

# Should be 'production' by default, otherwise use other env
rails_env = ENV['RAILS_ENV'] || 'production'

# Log everything to one file
stderr_path "log/unicorn.log"
stdout_path "log/unicorn.log"

# put the pid where capistrano expects it
pid "#{app_path}/tmp/pids/unicorn.pid"
