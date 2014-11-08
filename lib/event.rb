def box_event!(event)
  raise "Events must have a selector" unless event["selector"]
  raise "Tried to box an already boxed event" unless event["selector"].class == String

  begin
    event["selector"] = JSON.parse event["selector"]
  rescue => e
    raise "Could not convert selector string: #{event["selector"]} to a Hash using JSON.parse. Are you sure this event's selector is a JSON compatible string? Error yielded was: #{e.inspect}"
  end

  return event
end

def unbox_event!(event)
  raise "Events must have a selector" unless event["selector"]
  raise "Tried to unbox an unboxed event" unless event["selector"].class == Hash

  begin
    event["selector"] = event["selector"].to_json
  rescue => e
    raise "Could not convert selector hash: #{event["selector"].inspect} from a Hash using Hash#to_json.  Error yielded was: #{e.inspect}"
  end

  return event
end
