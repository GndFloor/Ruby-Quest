def main_event_loop
  loop do
    event = dequeue_event__blocking

    #Get info relevant to dispatching
    name = event["event_name"]
    context = event["event_context"]
    selector = event["event_selector"]

    if selector
      handle_selector_events event
    else
      handle_broadcast_events event
    end
  end
end

def handle_selector_events event
  #Instance is no longer valid. Probably removed the quest from the context but a scheduled event was dispatched
  if event["quest_instance"]
    return unless $redis.sismember(k_active_quest_instances__set, event["quest_instance"])
  end

  quest_name = quest_name_for_selector(event["event_selector"])
  action_name = action_name_for_selector(event["event_selector"])
  
  call_quest quest_name: quest_name, action_name: action_name, context: event["event_context"], event: event
end

def handle_broadcast_events event
  selectors = $redis.smembers k_selectors_for_event_name_and_context__set(event["event_name"], event["event_context"])
  
  selectors.each do |selector|
    event["event_selector"] = selector
    queue_event event
  end
end
