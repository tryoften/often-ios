
public class Event <EventData: Any> : Emitter {

  public func on (_ handler: (EventData) -> Void) -> Listener {
    return EmitterListener(self, nil, castData(handler), false)
  }
  
  public func on (_ target: AnyObject, _ handler: (EventData) -> Void) -> Listener {
    return EmitterListener(self, target, castData(handler), false)
  }
  
  public func once (_ handler: (EventData) -> Void) -> Listener {
    return EmitterListener(self, nil, castData(handler), true)
  }
  
  public func once (_ target: AnyObject, _ handler: (EventData) -> Void) -> Listener {
    return EmitterListener(self, target, castData(handler), true)
  }
  
  public func emit (_ data: EventData) {
    super.emit(nil, data)
  }

  public func emit (_ target: AnyObject, _ data: EventData) {
    super.emit(target, data)
  }
  
  public func emit (_ targets: [AnyObject], _ data: EventData) {
    super.emit(targets, data)
  }
  
  public override init () {
    super.init()
  }
  
  private func castData (_ handler: (EventData) -> Void) -> (Any!) -> Void {
    return { handler($0 as! EventData) }
  }
}
