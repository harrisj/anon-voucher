# frozen_string_literal: true

namespace :db do
  task :delete do
    `rm -f db.sqlite`
  end

  task create: :delete do
    require_relative 'lib/tasks/db_create'
    DB.create_tables
  end

  task :reseed do
    require_relative 'lib/tasks/db_seed'
    DB.reseed
  end
end
