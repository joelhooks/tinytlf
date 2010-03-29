package org.tiny.tlf.interaction.gestures.mouse
{
  import flash.events.Event;
  import flash.events.IEventDispatcher;
  import flash.events.MouseEvent;
  
  import org.tiny.tlf.interaction.gestures.Gesture;
  
  public class MouseDownGesture extends Gesture
  {
    public function MouseDownGesture()
    {
      hsm.appendChild(<down/>);
    }
    
    public function down(event:Event):Boolean
    {
      return (event is MouseEvent && event.type == MouseEvent.MOUSE_DOWN);
    }
    
    override protected function addListeners(target:IEventDispatcher):void
    {
      super.addListeners(target);
      target.addEventListener(MouseEvent.MOUSE_DOWN, execute);
    }
    
    override protected function removeListeners(target:IEventDispatcher):void
    {
      super.removeListeners(target);
      target.removeEventListener(MouseEvent.MOUSE_DOWN, execute);
    }
  }
}