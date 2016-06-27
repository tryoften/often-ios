
public class Signal : Emitter {

  public func on (_ handler: (Void) -> Void) -> Listener {
    return EmitterListener(self, nil, { _ in handler() }, false)
  }
  
  public func on (_ target: AnyObject, _ handler: (Void) -> Void) -> Listener {
    return EmitterListener(self, target, { _ in handler() }, false)
  }
  
  public func once (_ handler: (Void) -> Void) -> Listener {
    return EmitterListener(self, nil, { _ in handler() }, true)
  }
  
  public func once (_ target: AnyObject, _ handler: (Void) -> Void) -> Listener {
    return EmitterListener(self, target, { _ in handler() }, true)
  }
  
  public func emit () {
    super.emit(nil, nil)
  }
  
  public func emit (_ target: AnyObject) {
    super.emit(target, nil)
  }
  
  public func emit (_ targets: [AnyObject]) {
    super.emit(targets, nil)
  }
  
  public override init () {
    super.init()
  }
}
