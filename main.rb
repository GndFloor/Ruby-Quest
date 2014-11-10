require File.expand_path("./config/init.rb", File.dirname(__FILE__))

quest "my_quest" do
  action :init do
    @lol = "no"
  end

  action :my_action, :on => ["test"] do
    puts @lol
    @lol = 4
    puts @lol

    @hey = [3, 4, 5, 6]
  end

  action :other_action, :on => [] do
    puts @lol
    puts @hey
  end
end
context = SecureRandom.hex

add_quest_to_context("my_quest", context)
p $redis.smembers(k_active_quests_for_context__set(context))
add_quest_to_context("my_quest", context)

call_quest quest_name: "my_quest", action_name: "my_action", context: context, event: {}
call_quest quest_name: "my_quest", action_name: "other_action", context: context, event: {}
