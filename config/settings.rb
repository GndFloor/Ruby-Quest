#The prefix used for all redis entries
REDIS_PREFIX = "ruby_quest://"

#The primary queue that handles quest events
REDIS_QUEUE_KEY = "#{REDIS_PREFIX}/queue_key"
