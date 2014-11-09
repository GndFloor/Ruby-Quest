def cron_event_loop_start_bg
  Thread.new do
    begin
      loop do
        move_expired_priority_time_events_to_main_event_queue

        #Dequeue
        sleep 1.0/TICKS_PER_SECOND
      end
    rescue => e
      $stderr.puts "cron_event_loop has encountered an error: #{e.inspect}"
    end
  end
end
