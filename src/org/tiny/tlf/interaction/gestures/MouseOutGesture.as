package org.tiny.tlf.interaction.gestures
{
  import flash.events.Event;
  import flash.events.MouseEvent;

  public class MouseOutGesture extends GestureBase
  {
    public function MouseOutGesture()
    {
      hsm.appendChild(<out/>);
    }
    
    public function out(event:Event):Boolean
    {
      return event.type == MouseEvent.MOUSE_OUT;
    }
  }
}