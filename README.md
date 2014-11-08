Ruby-Quest
==========

A multiuser questing system on-top of Ruby and Redis.  This was purpose built for [Fittr®](www.fittr.com) to act as a server that was capabable of processing events that had some temporal logic.  It has evolved into a architecture capabable of supporting CRON types events (Every X days) and events that require dependencies (Do X within 10 minutes). Ruby-Quest is a suitable replacement for many stream processing systems.

##Redis Keys

Ruby-Quest relies on data stored in redis.  The following lists all the keys that contain data from ruby-quest.  Words with dollar-signs ($) are variables.  e.g. ``` $context.$event_name.selectors: Set ``` is a double pointer to a redis set

```ruby
#Per Context
################################################################################################
$context.active_quests: Set          #The current active quests for $context
$context.$event_name.selectors: Set  #The quests selectors that are applicable for a given context and event
$context.$quest_name.selectors: Set  #The given selectors applicable for a quest
$context.$quest_name.variables: Hash #The "instance" variables that are part of an active quest
$context.$quest_name.dereferences

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
  * data.rb  - Contains interface to database documents
  * event.rb - Useful helpers for processing events like unboxing & boxing
  * event_queue.rb - Handles the incomming and outgoing event data
