package org.tiny.tlf.interaction.gestures
{
  import flash.events.Event;
  import flash.events.IEventDispatcher;
  
  import org.tiny.tlf.events.GestureEvent;
  
  public class Gesture implements IGesture
  {
    public function Gesture()
    {
    }
    
    private var _target:IEventDispatcher;
    public function get target():IEventDispatcher
    {
      return _target;
    }
    
    public function set target(value:IEventDispatcher):void
    {
      if(value === _target)
        return;
      
      if(_target)
        removeListeners(_target);
      
      _target = value;
      
      if(_target)
        addListeners(_target);
      
      resetStates();
    }
    
    protected function addListeners(target:IEventDispatcher):void
    {
    }
    
    protected function removeListeners(target:IEventDispatcher):void
    {
    }
    
    protected var hsm:XML = <_/>;
    protected var states:XMLList = <>{hsm}</>;
    
    protected var behaviors:Vector.<IEventDispatcher> = new Vector.<IEventDispatcher>();
    
    public function addBehavior(behavior:IEventDispatcher):void
    {
      if(behaviors.indexOf(behavior) == -1)
        behaviors.push(behavior);
    }
    
    public function execute(event:Event):void
    {
      var childStates:XMLList = getChildStates();
      resetStates();
      for each(var childState:XML in childStates)
      {
        if(states.contains(childState))
          continue;
        
        if(!(childState.localName() in this))
          throw new ArgumentError('State name missing matching Gesture method.');
        
        if(!this[childState.localName()](event))
          continue;
        
        if(testNotifiable(childState))
          notifyBehaviors(event);
        
        states += childState;
      }
    }
    
    protected function resetStates():void
    {
      states = <>{hsm}</>;
    }
    
    protected function getChildStates():XMLList
    {
      var childStates:XMLList = states/*.(!attribute('idrefs').length() || attribute('idrefs') == "*")*/.*;
      var namedStates:XMLList = hsm..*.(attribute('id').length());
      for each(var childStateID:String in states.@idrefs.toXMLString().split(/\s+/))
        if(childStateID)
          childStates += namedStates.(@id == childStateID);
      
      return childStates;
    }
    
    protected function testNotifiable(state:XML):Boolean
    {
      return(state.@idrefs.toString() == "" || state.@idrefs == "*") && !state.*.length();
    }
    
    protected function notifyBehaviors(event:Event):void
    {
      for each(var behavior:IEventDispatcher in behaviors)
        behavior.dispatchEvent(new GestureEvent(GestureEvent.ACTIVATED, event));
    }
  }
}