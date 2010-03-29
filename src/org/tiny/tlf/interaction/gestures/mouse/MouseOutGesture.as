package org.tiny.tlf.interaction.gestures.mouse
{
  import flash.events.Event;
  import flash.events.IEventDispatcher;
  import flash.events.MouseEvent;
  import org.tiny.tlf.interaction.gestures.Gesture;

  public class MouseOutGesture extends Gesture
  {
    public function MouseOutGesture()
    {
      hsm.appendChild(<out/>);
    }
    
    public function out(event:Event):Boolean
    {
      return (event is MouseEvent && event.type == MouseEvent.MOUSE_OUT);
    }
    
    override protected function addListeners(target:IEventDispatcher):void
    {
      super.addListeners(target);
      target.addEventListener(MouseEvent.MOUSE_OUT, execute);
    }
    
    override protected function removeListeners(target:IEventDispatcher):void
    {
      super.removeListeners(target);
      target.removeEventListener(MouseEvent.MOUSE_OUT, execute);
    }
  }
}