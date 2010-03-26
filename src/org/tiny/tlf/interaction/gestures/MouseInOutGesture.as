package org.tiny.tlf.interaction.gestures
{
  import flash.events.Event;
  import flash.events.MouseEvent;

  public class MouseInOutGesture extends GestureBase
  {
    public function MouseInOutGesture()
    {
      hsm.appendChild(<move><out/></move>);
    }
    
    public function move(event:Event):Boolean
    {
      return event.type == MouseEvent.MOUSE_MOVE;
    }
    
    public function out(event:Event):Boolean
    {
      return event.type == MouseEvent.MOUSE_OUT;
    }
    
    override protected function notifyBehaviors(event:Event):void
    {
      trace("in_out gesture");
    }
  }
}