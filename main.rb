require File.expand_path("./config/init.rb", File.dirname(__FILE__))

#An example quest
quest :my_quest do
  action :my_action, :on => ["my_event"] do
    puts "Helo from my_action"
  end
end

context = "my_context"
add_quest_to_context "my_quest", context

#Test directly calling quest
call_quest quest_name: "my_quest", action_name: "my_action", context: context, event: {}
