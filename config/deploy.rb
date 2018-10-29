lock '3.8.0'

set :application, ''
set :repo_url, ''
set :keep_releases, 5
set :deploy_to, ''
set :pty, true
set :ssh_options, forward_agent: true

set :linked_files, fetch(:linked_files, []) + %w[config/database.yml config/secrets.yml]
set :linked_dirs, fetch(:linked_dirs, []) + %w(log tmp/pids tmp/cache tmp/sockets public/system public/uploads)

set :db_local_clean, true
set :db_remote_clean, true
set :disallow_pushing, true

%i[web_app_server].each do |service_name|
  namespace service_name do
    %i[start stop restart].each do |command|
      task command do
        on release_roles :all do
          execute "/usr/bin/sv -w 60 #{command} #{service_name}"
        end
      end
    end
  end
end

namespace :deploy do
  after :finishing, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        invoke 'web_app_server:restart'
      end
    end
  end

  task :setup do
    on release_roles :all do
      within release_path do
        with rails_env: fetch(:rails_env) do
          rake 'db:create'
          rake 'db:migrate'
          rake 'db:seed'
        end
      end
    end
  end
end

namespace :app do
  task :tmp_clear do
    on release_roles :app do
      within release_path do
        with rails_env: fetch(:rails_env) do
          rake 'tmp:clear'
        end
      end
    end
  end
end

before 'deploy:assets:precompile', 'deploy:spa'
