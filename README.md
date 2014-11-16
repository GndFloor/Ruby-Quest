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
```

##Console / Start Server
```ruby
#Start a Quest server
(sh)>bundle exec thor questing:server

#Get the full listing of commands
(sh)>bundle exec thor list

#Send a test event
(sh)>bundle exec thor questing:send_test_event

#Continually dequeue events from the main event queue and inspect these events
(sh)>bundle exec thor questing:dump_events
```

##Redis Keys

Ruby-Quest relies on data stored in redis.  The following lists all the keys that contain data from ruby-quest.  Words with dollar-signs ($) are variables.  e.g. ``` $context.$event_name.selectors: Set ``` is a double pointer to a redis set


```ruby
#Per Context
################################################################################################
$context.active_quests: Hash         #{'my_quest0':'37F..', 'my_quest1':'2B5'} i.e. <name, instance>
$context.$event_name.selectors: Set  #The quests selectors that are applicable for a given context and event
$context.$quest_name.variables: Hash #The "instance" variables that are part of an active quest

#Global
################################################################################################
active_quest_instances: Set          #All active quest instances

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
  * quest.rb           - Manages the quest DSL
  * cron/
    * cron_event_loop  - Analagous to the main_event_loop, except this one manages the time priority and time general events
    * priority_time_event_queue - A special priority queue that moves events to the main queue when they are ready to be fired

##Event example
```ruby
#Fully qualified selector event. Will result in one action call.
{
  event_name: 'test_event',
  event_context: 'context',
  event_selector: '<selector>'
}

#Fully qualified selector event. Quest instance verifies quest is still part of context, used for scheduled events. Will result in one action call.
{
  event_name: 'test_event',
  event_context: 'context',
  event_selector: '<selector>',
  quest_instance: '<random hash>',
}

#Context specific broadcast event. Will result in all applicable fully
#qualified selector events.
{
  event_name: 'test_event',
  event_context: 'context'
}
```

##Known issues

1. An event with a context but no selector is known as a multicast event.  When a multicast event is recieved, Quest figures out what selectors are applicable to the multicast event and then sends out a new event for each applicable selector where each new event is the original multicast event with a little more specificity. If a quest is removed from a context during this second dispatch, there is no check to make sure that the event is still valid for a quest.  Even if the quest is re-added, there is no guarantee that 'this' quest is equal to 'that' quest, even if they carry the same name.  Schedule does this currently, and it would be easy to implement for the multicast dispatch by following the quest_instance protocol.

2. Multiple daemons will have concurrency issues.  The cron daemon will attempt to pick off from each active daemon which could have some contention issues. Need to implement better locking procedures. This case also exists with multiple entries into a quest.

3. During server shutdown, we need to make sure that an event is not currently being processed.
