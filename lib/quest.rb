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
