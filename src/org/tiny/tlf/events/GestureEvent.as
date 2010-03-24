package org.tiny.tlf.events
{
  import flash.events.Event;
  
  public class GestureEvent extends Event
  {
    public static const ACTIVATED:String = "gestureActivated";
    
    protected var _event:Event;
    public function GestureEvent(type:String, originalEvent:Event, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      _event = originalEvent;
      super(type, bubbles, cancelable);
    }
    
    public function get originatingEvent():Event
    {
      return _event;
    }
  }
}