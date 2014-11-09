require File.expand_path("./config/init.rb", File.dirname(__FILE__))

$redis.pipelined do
1000.times do
queue_priority_time_event({event_name: "5", lol: SecureRandom.hex}, Time.now+2)
queue_priority_time_event({event_name: "4", lol: SecureRandom.hex}, Time.now+3)
queue_priority_time_event({event_name: "3", lol: SecureRandom.hex}, Time.now+4)
queue_priority_time_event({event_name: "2", lol: SecureRandom.hex}, Time.now+5)
queue_priority_time_event({event_name: "1", lol: SecureRandom.hex}, Time.now+6)
end
end

cron_event_loop_start_bg
main_event_loop
