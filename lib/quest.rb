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
  action "init" do
    @lol = "Hi"
  end

  action "dealloc" do
    puts "Default finialize action"
  end
  ######################################################################

  yield
end

def call_quest(quest_name:, action_name:, context:, event:)
  @context = context
  @event = event
  @action_name = action_name
  @quest_name = quest_name

  instance_variables = {}

  #Call and detect changes to instance variables
  instance_variables_before = self.instance_variables

  #Load instance variables from redis
  instance_variables_string = $redis.get k_variables_for_quest_name_and_context__string(@quest_name, @context)
  instance_variables_string ||= "{}"
  begin
    instance_variables = JSON.parse(instance_variables_string)
  rescue => e
    raise "Could not parse instance_variables from quest: #{@quest_name}, instance variables retrieved was #{instance_variables_string}.  Error: #{e.inspect}"
  end
  
  $quests_hash[quest_name][action_name][:block].call

  #Add new instance variables
  new_instance_variables = self.instance_variables - instance_variables_before
  new_instance_variables.each do |instance_variable|
    instance_variables[instance_variable] = self.instance_variable_get(instance_variable)
  end

  #Save instance variables
  begin
    instance_variables_string = instance_variables.to_json
  rescue => e
    raise "Could not convert instance variables back into a JSON string for storing in the database.  Please check that the given instance variables are serializable objects.  I'm trying to serialize: #{instance_variables.inspect}, error: #{e.inspect}"
  end

  $redis.set k_variables_for_quest_name_and_context__string(@quest_name, @context), instance_variables_string
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
  event_name_to_selectors = {}
  quest_hash.each do |action_name, info|
    info[:on].each do |event_name|
      event_name_to_selectors[event_name] ||= []
      event_name_to_selectors[event_name] << selector_for(quest_name: quest_name, action_name: action_name)
    end
  end

  event_name_to_selectors.each do |event_name, selectors|
    $redis.sadd(k_selectors_for_event_name_and_context__set(event_name, context), selectors)
  end

  #Call quest init function and retrieve used instance variables
  call_quest(quest_name: quest_name, action_name: "init", context: context, event: {})

  #Add these instance variables and their values to redis
end

def remove_quest_from_context(quest_name, context)
  #Verify quest exists
  raise "No such quest named #{quest_name.inspect}" unless $quests_hash[quest_name]

  quest_hash = $quests_hash[quest_name]
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
