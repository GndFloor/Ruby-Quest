#Create a new quest 'my_quest' with one action
#'my_action'. Add this quest to context 'context'
quest :my_quest do
  action :init do
    at Time.now+5, :my_action
  end
  action :my_action, :on => ["my_event"] do
    puts "Hello from my_action"
  end
end

remove_quest_from_context "my_quest", "context"
add_quest_to_context "my_quest", "context"
