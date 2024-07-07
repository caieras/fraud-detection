require 'sequel'

namespace :db do
  DB = Sequel.connect(
    adapter: 'postgres',
    host: ENV.fetch('DB_HOST', 'localhost'),
    port: ENV.fetch('DB_PORT', 5432),
    database: ENV.fetch('DB_NAME', 'fraud_detection_development'),
    user: ENV.fetch('DB_USER', 'postgres'),
    password: ENV.fetch('DB_PASSWORD', 'password')
  )

  migrate = lambda do |version|
    Sequel.extension :migration
    Sequel::Migrator.run(DB, 'db/migrations', target: version)
  end

  desc 'Run migrations'
  task :migrate do
    migrate.call(nil)
  end

  desc 'Rollback last migration'
  task :rollback do
    latest = DB[:schema_info].select_map(:version).first
    migrate.call(latest - 1)
  end

  desc 'Reset database'
  task :reset do
    migrate.call(0)
    Sequel::Migrator.run(DB, 'db/migrations')
  end
end

