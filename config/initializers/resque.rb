require 'resque_scheduler'

# If you want to be able to dynamically change the schedule,
# uncomment this line.  A dynamic schedule can be updated via the
# Resque::Scheduler.set_schedule (and remove_schedule) methods.
# When dynamic is set to true, the scheduler process looks for
# schedule changes and applies them on the fly.
# Note: This feature is only available in >=2.0.0.
#Resque::Scheduler.dynamic = true

Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }

# The schedule doesn't need to be stored in a YAML, it just needs to
# be a hash.  YAML is usually the easiest.
Resque.schedule = YAML.load_file(Rails.root.join('config', 'resque_schedule.yml'))

# configure redis connection
# REDIS_CONFIG = YAML.load( File.open( Rails.root.join("config/redis.yml") ) ).symbolize_keys
REDIS_CONFIG = YAML.load_file(Rails.root.join('config', 'redis.yml')).symbolize_keys
dflt = REDIS_CONFIG[:default].symbolize_keys
cnfg = dflt.merge(REDIS_CONFIG[Rails.env.to_sym].symbolize_keys) if REDIS_CONFIG[Rails.env.to_sym]

$redis = Redis.new(cnfg)
# $redis_ns = Redis::Namespace.new(cnfg[:namespace], :redis => $redis) if cnfg[:namespace]

# To clear out the db before each test
# $redis.flushdb if Rails.env = "test"

# Resque.redis.namespace = "resque:caregaroo"
# config = YAML.load_file(Rails.root.join('config', 'redis.yml'))
# $redis = Redis.new(config[Rails.env])
# Resque.redis = config[Rails.env]
# $redis.flushdb if Rails.env = "test"

