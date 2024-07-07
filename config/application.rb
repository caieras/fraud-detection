require 'sinatra/base'
require 'sequel'

class Application < Sinatra::Base
  configure do
    template = ERB.new File.new('config/database.yml').read
    db_config = YAML.load(template.result(binding), aliases: true)
    db_config = db_config["#{environment}"]

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

    enable :logging
  end
end

loader = Zeitwerk::Loader.new
loader.push_dir(File.expand_path('../lib', __dir__))
loader.setup
