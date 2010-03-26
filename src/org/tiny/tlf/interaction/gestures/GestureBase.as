package org.tiny.tlf.interaction.gestures
{
  import flash.events.Event;
  import flash.events.IEventDispatcher;
  
  import org.tiny.tlf.events.GestureEvent;
  
  public class GestureBase implements IGesture
  {
    public function GestureBase()
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
      states = <>{hsm}</>;
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
        else if(!states.contains(childState))
          states.appendChild(childState);
      }
    }
    
    protected function getChildStates():XMLList
    {
      var childStates:XMLList = states.(!attribute('idrefs').length() || attribute('idrefs') == "*").*;
      for each(var childStateID:String in states.@idrefs.toXMLString().split(/\s+/))
        if(childStateID)
          childStates += states..*.(attribute('id') == childStateID);
      
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