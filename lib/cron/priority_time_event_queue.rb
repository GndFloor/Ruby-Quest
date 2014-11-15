def move_expired_priority_time_events_to_main_event_queue
  #Find events that need to be moved *now*
  expired_events = $redis_cron.zrangebyscore REDIS_FUTURE_PRIORITY_QUEUE_KEY, 0, Time.now.to_i
  $redis_cron.zremrangebyscore REDIS_FUTURE_PRIORITY_QUEUE_KEY, 0, Time.now.to_i

  $redis_cron.pipelined do
    expired_events.each do |expired_event|
      $redis_cron.lpush REDIS_QUEUE_KEY, expired_event
    end
  end

  return expired_events
end

def schedule(event:, time:)
  stringized_event = event.to_json
  $redis_cron.zadd REDIS_FUTURE_PRIORITY_QUEUE_KEY, time.to_i, stringized_event
end
