#The prefix used for all redis entries
REDIS_PREFIX = "ruby_quest://"

#The primary queue that handles quest events
REDIS_QUEUE_KEY = "#{REDIS_PREFIX}queue"

#Queue managed by cron that publishes future events into the main queue
REDIS_FUTURE_PRIORITY_QUEUE_KEY = "#{REDIS_PREFIX}future_priority_queue"

#Number of times per second the cron event queue is checked
TICKS_PER_SECOND = 1
