package org.tiny.tlf.interaction.gestures.keyboard
{
  import flash.events.Event;
  import flash.events.IEventDispatcher;
  import flash.events.KeyboardEvent;
  import flash.ui.Keyboard;
  
  import org.tiny.tlf.interaction.gestures.Gesture;
  import org.tiny.tlf.utils.KeyboardUtil;

  public class KeyboardGesture extends Gesture
  {
    public function KeyboardGesture()
    {
      hsm.appendChild(<t />);
    }
    
    public function t(event:Event):Boolean
    {
      var result:Boolean = event is KeyboardEvent && 
        (String.fromCharCode(KeyboardEvent(event).keyCode).toLowerCase() == "t" || String.fromCharCode(KeyboardEvent(event).charCode).toLowerCase() == "t") &&
        KeyboardEvent(event).ctrlKey &&
        KeyboardEvent(event).shiftKey;
//      trace("t: " + result);
      return result;
    }
    
    override protected function notifyBehaviors(event:Event):void
    {
      trace("ctrl shift t");
    }
    
    override protected function addListeners(target:IEventDispatcher):void
    {
      super.addListeners(target);
      target.addEventListener(KeyboardEvent.KEY_DOWN, execute);
    }
    
    override protected function removeListeners(target:IEventDispatcher):void
    {
      super.removeListeners(target);
      target.removeEventListener(KeyboardEvent.KEY_DOWN, execute);
    }
  }
}