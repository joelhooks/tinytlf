package org.tiny.tlf.interaction.gestures.behaviors
{
  import flash.events.IEventDispatcher;
  
  import org.tiny.tlf.events.GestureEvent;
  import org.tiny.tlf.interaction.TextDispatcherBase;
  
  public class Behavior extends TextDispatcherBase
  {
    public function Behavior(target:IEventDispatcher=null)
    {
      super(target, false);
      
      addEventListener(GestureEvent.ACTIVATED, activate);
    }
    
    protected function activate(event:GestureEvent):void
    {
    }
  }
}