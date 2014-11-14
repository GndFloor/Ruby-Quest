def main_event_loop
  loop do
    event = dequeue_event__blocking

    #Get info relevant to dispatching
    name = event["event_name"]
    context = event["event_context"]
    selector = event["event_selector"]

    #Extract info from selector
    quest_name = quest_name_for_selector(selector)
    action_name = action_name_for_selector(selector)

    #Call
    call_quest quest_name: quest_name, action_name: action_name, context: context, event: event
  end
end
