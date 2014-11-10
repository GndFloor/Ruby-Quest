
####################################################################################################
#Quests for the current context
def k_active_quests_for_context__set(context)
  "#{REDIS_PREFIX}#{context}.active_quests"
end

#Get a list of selectors (quest+action) for an event and context
def k_selectors_for_event_name_and_context__set(event_name, context)
  "#{REDIS_PREFIX}#{context}.#{event_name}.selectors"
end

#Lookup a list of selectors (quest+action) for a particular quest
def k_selectors_for_quest_name_and_context__set(quest_name, context)
  "#{REDIS_PREFIX}#{context}.#{quest_name}.selectors"
end

#Lookup member variables for a particular context
def k_variables_for_quest_name_and_context__hash(quest_name, context)
  "#{REDIS_PREFIX}#{context}.#{quest_name}.variables"
end

#Lookup all matching contexts for an event name
def k_contexts_for_event_name__set(event_name)
  "#{REDIS_PREFIX}#{event_name}.cntexts"
end
####################################################################################################
