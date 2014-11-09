def dequeue_event__blocking
  stringized_event = $redis.blpop(REDIS_QUEUE_KEY, 0)[1]

  event = nil
  begin
    event = JSON.parse(stringized_event)
  rescue => e
    raise "Could not parse incomming event as JSON string.  Event string: #{stringized_event.inspect}, error: #{e.inspect}"
  end

  return event
end

def queue_event event
  stringized_event = event.to_json
  $redis.lpush REDIS_QUEUE_KEY, stringized_event
end
