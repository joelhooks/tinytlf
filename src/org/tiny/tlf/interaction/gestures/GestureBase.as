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
    
    protected var state:XML = <_></_>;
    protected var currentState:XML;
    
    protected var behaviors:Vector.<IEventDispatcher> = new Vector.<IEventDispatcher>();
    
    public function addBehavior(behavior:IEventDispatcher):void
    {
      if(behaviors.indexOf(behavior) < 0)
        behaviors.push(behavior);
    }
    
    public function execute(event:Event):void
    {
      currentState = (event.type in currentState) ? XML(currentState[event.type]) : state;
    }
    
    protected function notifyBehaviors(event:Event):void
    {
      var tmp:Vector.<IEventDispatcher> = behaviors.concat();
      while(tmp.length > 0)
        tmp.pop().dispatchEvent(new GestureEvent(GestureEvent.ACTIVATED, event));
    }
  }
}