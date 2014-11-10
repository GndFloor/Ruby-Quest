require File.expand_path("./config/init.rb", File.dirname(__FILE__))

quest "my_quest" do

end
context = SecureRandom.hex

add_quest_to_context("my_quest", context)
p $redis.smembers(k_active_quests_for_context__set(context))
add_quest_to_context("my_quest", context)
