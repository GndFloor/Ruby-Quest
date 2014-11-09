def main_event_loop
  loop do
    event = dequeue_event__blocking
    dispatch_event_to_global_handler(event)
  end
end
