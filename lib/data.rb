def active_quests_for_context(context)
  $redis.smembers("#{REDIS_PREFIX}#{context}.active_quests")
end

def selectors_for_event_name_and_context(event_name, context)
  $redis.smembers("#{REDIS_PREFIX}#{context}.#{event_name}.selectors")
end

def selectors_for_quest_name_and_context(quest_name, context)
  $redis.smembers("#{REDIS_PREFIX}#{context}.#{quest_name}.selectors")
end

def variables_for_quest_name_and_context(quest_name, context)
  $redis.smembers("#{REDIS_PREFIX}#{context}.#{quest_name}.variables")
end

def contexts_for_event_name(event_name)
  $redis.smembers("#{REDIS_PREFIX}#{event_name}.contexts")
end
