def main_event_loop
  loop do
    event = deque_event_blocking
    dispatch_event_to_global_handler(event)
  end
end
