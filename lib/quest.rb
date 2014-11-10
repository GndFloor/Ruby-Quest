#Contains a hash that maps quest_names onto another hash 
#that contains quests names.  Lookup-table for class like
#interface.
#$quest_name.$action_name.block -> Stores the actual lambda expression of an action
#$quest_name.$action_name.on -> Stores the list of events this action is sensetive to
#{
#  "my_quest" => {
#    "my_action" => {
#      :block => {
#      },
#      :on => [
#        "my_event_a"
#      ],
#    }
#  }
#}
$quests_hash = {}

def action name, params={:on => []}, &block
  raise "params must supply an on argument with an array of possible events" unless params[:on] and params[:on].class == Array
  name = name.to_s
  $quests_hash[@quest_name][name] = {}
  $quests_hash[@quest_name][name][:on] = params[:on]
  $quests_hash[@quest_name][name][:block] = block
end

def quest name
  #Setup a new quest with this name
  @quest_name = name.to_s
  $quests_hash[@quest_name] = {}

  #Add default overridable actions
  ######################################################################
  action "initialize" do
    puts "Default Init Action"
  end

  action "finalize" do
    puts "Default finialize action"
  end
  ######################################################################

  yield
end

#Modify quests
def add_quest_to_context(quest_name, context)
  #Verify quest exists
  raise "No such quest named #{quest_name.inspect}" unless $quests_hash[quest_name]

  quest_hash = $quests_hash[quest_name]
  
  quest_was_active = !$redis.sadd(k_active_quests_for_context__set(context), quest_name)
  return if quest_was_active

  #Get all selector names for quest
  quest_selectors = quest_hash.map do |action_name, info|
    selector_for quest_name: quest_name, action_name: action_name
  end
  $redis.sadd k_selectors_for_quest_name_and_context__set(quest_name, context), quest_selectors

  #Collect selectors based on what events
  #each action responds to
  event_name_to_selectors = Hash.new([])
  quest_hash.each do |action_name, info|
    info[:on].each do |event_name|
      event_name_to_selectors[event_name] << selector_for(quest_name: quest_name, action_name: action_name)
    end
  end

  event_name_to_selectors.each do |event_name, selectors|
    $redis.sadd(k_selectors_for_event_name_and_context__set(event_name, context), selectors)
  end
end

#Helper utilities
###########################################################################
def selector_for(quest_name:, action_name:)
  {quest_name: quest_name, action_name: action_name}.to_json
end

def quest_name_for_selector selector
  return JSON.parse(selector)["quest_name"]
rescue => e
  raise "Could not parse quest_name from selector after trying to convert: #{selector.inspect} from json, Error: #{e.inspect}"
end

def action_name_for_selector selector
  return JSON.parse(selector)["action_name"]
rescue => e
  raise "Could not parse action_name from selector after trying to convert: #{selector.inspect} from json, Error: #{e.inspect}"
end
