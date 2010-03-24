package org.tiny.tlf.interaction.gestures.behaviors
{
  import flash.events.IEventDispatcher;
  
  import org.tiny.tlf.events.GestureEvent;
  import org.tiny.tlf.interaction.TextDispatcherBase;
  
  public class BehaviorBase extends TextDispatcherBase
  {
    public function BehaviorBase(target:IEventDispatcher=null)
    {
      super(target);
      
      addEventListener(GestureEvent.ACTIVATED, activate);
    }
    
    protected function activate(event:GestureEvent):void
    {
    }
  }
}