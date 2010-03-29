package org.tiny.tlf.interaction.gestures.behaviors
{
  import flash.ui.Mouse;
  import flash.ui.MouseCursor;
  
  import org.tiny.tlf.events.GestureEvent;
  
  public class MouseIBeamOffBehavior extends Behavior
  {
    override protected function activate(event:GestureEvent):void
    {
      Mouse.cursor = MouseCursor.ARROW;
    }
  }
}