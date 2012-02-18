#uri = URI.parse("redis://localhost:6379/")  
#Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)  
require 'redis'
require 'resque'
require 'resque_scheduler'
require 'resque/scheduler'

$redis = Redis.new :host => '127.0.0.1' # default port : 6379

rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'
resque_config = YAML.load_file(rails_root + '/config/resque.yml')
Resque.redis = resque_config[rails_env]

Dir[File.join(rails_root,'app','jobs','*.rb')].each { |file| require file }

#Resque::Scheduler.dynamic = true
Resque.schedule = YAML.load_file(rails_root + '/config/resque_scheduler.yml')


