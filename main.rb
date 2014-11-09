require File.expand_path("./config/init.rb", File.dirname(__FILE__))

quest :my_quest do
  action :my_action, :on => ["my_situation"] do
  end
end

p $quests_hash

cron_event_loop_start_bg
main_event_loop
