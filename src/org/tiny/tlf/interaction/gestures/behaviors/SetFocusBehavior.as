package org.tiny.tlf.interaction.gestures.behaviors
{
  import flash.events.IEventDispatcher;
  
  import org.tiny.tlf.events.GestureEvent;
  import org.tiny.tlf.interaction.LineInfo;
  
  public class SetFocusBehavior extends Behavior
  {
    override protected function activate(event:GestureEvent):void
    {
      var info:LineInfo = LineInfo.getInfo(event.originatingEvent, null);
      
      if(!info)
        return;
      
      info.line.stage.focus = info.line;
    }
  }
}