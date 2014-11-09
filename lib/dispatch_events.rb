def dispatch_event_to_global_handler event
  raise "Tried to dispatch an event but the event has no event_name.  I do not know who to deliver it to internally.  Full event #{event.inspect}" unless event["event_name"]

  event_name = event["event_name"]

  p "STUB: Got event with event_name: #{event_name}"
end
