Ruby-Quest
==========

A multiuser questing system on-top of Ruby and Redis.  This was purpose built for [Fittr®](www.fittr.com) to act as a server that was capabable of processing events that had some temporal logic.  It has evolved into a architecture capabable of supporting CRON types events (Every X days) and events that require dependencies (Do X within 10 minutes). Ruby-Quest is a suitable replacement for many stream processing systems.

##Redis Keys

Ruby-Quest relies on data stored in redis.  The following lists all the stored data entries.  Words with dollar-signs ($) are variables.  e.g. ``` $context.$event_name.selectors: Set ``` is a double pointer to a redis set

```ruby
$context.active_quests: Set
$context.$event_name.selectors: Set
$context.$quest_name.selectors: Set
$context.$quest_name.variables: Hash
```
