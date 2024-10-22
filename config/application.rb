# frozen_string_literal: true

require 'sinatra/base'
require 'sequel'

class Application < Sinatra::Base
  configure do
    set :root, File.dirname(__FILE__)

    template = ERB.new File.new('config/database.yml').read
    db_config = YAML.load(template.result(binding), aliases: true)
    db_config = db_config[environment.to_s]

    set :database,
        Sequel.connect(
          adapter: db_config['adapter'],
          host: db_config['host'],
          port: db_config['port'],
          username: db_config['username'],
          password: db_config['password'],
          database: db_config['database'],
          pool: db_config['pool']
        )

    set :redis, Redis.new(
      host: ENV['REDIS_HOST'] || 'localhost',
      port: 6379
    )

    Redis::Objects.redis = Application.redis
    enable :logging
  end
end

loader = Zeitwerk::Loader.new
loader.push_dir(File.expand_path('../lib', __dir__))
loader.setup
