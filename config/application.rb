require 'sinatra/base'
require 'sequel'

class Application < Sinatra::Base
  configure do
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

    redis_config = YAML.load_file('config/redis.yml')[environment.to_s]
    set :redis, Redis.new(
      host: redis_config['host'],
      port: redis_config['port'],
    )

    enable :logging
  end
end

loader = Zeitwerk::Loader.new
loader.push_dir(File.expand_path('../lib', __dir__))
loader.setup
