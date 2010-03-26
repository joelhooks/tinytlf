package org.tiny.tlf.interaction.gestures
{
  import flash.events.Event;
  import flash.events.MouseEvent;
  
  public class MouseOverGesture extends GestureBase
  {
    public function MouseOverGesture()
    {
      hsm.appendChild(<moved/>);
    }
    
    public function moved(event:Event):Boolean
    {
      return event.type == MouseEvent.MOUSE_MOVE;
    }
  }
}