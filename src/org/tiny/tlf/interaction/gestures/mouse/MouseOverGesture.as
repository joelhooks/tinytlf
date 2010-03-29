package org.tiny.tlf.interaction.gestures.mouse
{
  import flash.events.Event;
  import flash.events.IEventDispatcher;
  import flash.events.MouseEvent;
  import org.tiny.tlf.interaction.gestures.Gesture;
  
  public class MouseOverGesture extends Gesture
  {
    public function MouseOverGesture()
    {
      hsm.appendChild(<move/>);
    }
    
    public function move(event:Event):Boolean
    {
      return event is MouseEvent && event.type == MouseEvent.MOUSE_MOVE;
    }
    
    override protected function addListeners(target:IEventDispatcher):void
    {
      super.addListeners(target);
      target.addEventListener(MouseEvent.MOUSE_MOVE, execute);
    }
    
    override protected function removeListeners(target:IEventDispatcher):void
    {
      super.removeListeners(target);
      target.removeEventListener(MouseEvent.MOUSE_MOVE, execute);
    }
  }
}