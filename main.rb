require File.expand_path("./config/init.rb", File.dirname(__FILE__))

quest :my_example_quest do
  action :init do
    #Create a new instance variable
    @counter = 0
  end

  action :my_action, :on => ["test_event"] do
    @counter += 1
    p @counter
  end
end

context = "a_user_session_key"
add_quest_to_context "my_example_quest", context

call_quest quest_name: "my_example_quest", action_name: "my_action", context: context, event: {}
call_quest quest_name: "my_example_quest", action_name: "my_action", context: context, event: {}
