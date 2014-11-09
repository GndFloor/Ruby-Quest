require File.expand_path("./config/init.rb", File.dirname(__FILE__))

quest "my_quest" do

end

cron_event_loop_start_bg
main_event_loop
