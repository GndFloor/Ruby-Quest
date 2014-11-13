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

quest :my_example_quest_2 do
  action :init do
    #Create a new instance variable
    @counter = 0
  end

  action :my_action, :on => ["test_event", "other_event"] do
    @counter += 1
    p @counter
  end
end


context = "a_user_session_key"
context2 = "a_user_session_key_2"

add_quest_to_context "my_example_quest", context
add_quest_to_context "my_example_quest_2", context

#remove_quest_from_context "my_example_quest", context
#remove_quest_from_context "my_example_quest_2", context

add_quest_to_context "my_example_quest", context2
add_quest_to_context "my_example_quest_2", context2

#remove_quest_from_context "my_example_quest_2", context2


#call_quest quest_name: "my_example_quest", action_name: "my_action", context: context, event: {}
#call_quest quest_name: "my_example_quest", action_name: "my_action", context: context, event: {}
