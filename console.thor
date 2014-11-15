require File.expand_path("./config/init.rb", File.dirname(__FILE__))

class Questing < Thor
  desc "send_test_event", "Queue an example event"
  def send_test_event
    test_event_selector = selector_for(quest_name: "my_quest", action_name: "my_action")

    my_event = {
      event_name: "my_event",
      event_context: "context"
    }

    5.times { queue_event(my_event) }
  end

  desc "dump_events", "Grab and print out incomming events"
  def dump_events
    loop do
      event = dequeue_event__blocking
      puts ""
      puts "#"*40
      ap event
      puts "#"*40
    end
  end

  desc "server", "Start a Quest instance"
  def server
    load './test/attach_my_quest_to_context.rb'
    cron_event_loop_start_bg
    main_event_loop
  end
end
