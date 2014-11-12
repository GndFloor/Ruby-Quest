Ruby-Quest
==========

A multiuser questing system on-top of Ruby and Redis.  This was purpose built for [Fittr®](www.fittr.com) to act as a server that was capabable of processing events that had some temporal logic.  It has evolved into a architecture capabable of supporting CRON types events (Every X days) and events that require dependencies (Do X within 10 minutes). Ruby-Quest is a suitable replacement for many stream processing systems.

##Get started
```ruby
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

#>bundle exec ruby main.rb
#1
#2
```

##Redis Keys

Ruby-Quest relies on data stored in redis.  The following lists all the keys that contain data from ruby-quest.  Words with dollar-signs ($) are variables.  e.g. ``` $context.$event_name.selectors: Set ``` is a double pointer to a redis set


```ruby
#Per Context
################################################################################################
$context.active_quests: Set          #The current active quests for $context
$context.$event_name.selectors: Set  #The quests selectors that are applicable for a given context and event
$context.$quest_name.selectors: Set  #The given selectors applicable for a quest
$context.$quest_name.variables: Hash #The "instance" variables that are part of an active quest

#Global
################################################################################################
$event_name.selectors                #Selectors for an event that have been declared as global.  These contain binded contexts.

selector_to_&selector


```

##Files
* config/
  * init.rb - Initialize an environment from scratch
  * settings.rb - Contains configuration handles like redis prefix
  * initializers/* - Any *.rb files in here will be loaded automatically at startup
* lib/
  * data.rb            - Contains interface to database documents
  * event_queue.rb     - Handles the incomming and outgoing event data
  * main_event_loop.rb - Process events or block
  * dispatch_events.rb - Manages dispatching events to the appropriate handlers
  * quest.rb           - Manages the quest DSL
  * cron/
    * cron_event_loop  - Analagous to the main_event_loop, except this one manages the time priority and time general events
    * priority_time_event_queue - A special priority queue that moves events to the main queue when they are ready to be fired

##Event example
``ruby
#event_name
#  The name of this event
#event_context [Optional]
#  The context that may have an active quest with listeners bound to events with this event_name.
#event_selector [Optional]
#  What quest and action handlers is this event destined to? This is added by ruby-quest internally
#  after inferring the possible handlers from the event_name nad event_context
example_event = {
  event_name: "my_event_name",
  event_context: "cb02ea811d518fbcbac71857b3b69654",
  event_selector: "my_quest#my_action"
}

#The valid combinations are 
# {event_name} - Multicast to all relavent contexts
# {event_name, event_context} - Multicast to all relavent event_selector(s)
# {event_name, event_context, event_selector} - Send to one specific quest action
```
