package org.tiny.tlf.interaction.gestures
{
  import flash.events.Event;
  
  public class MouseOverGesture extends GestureBase
  {
    public function MouseOverGesture()
    {
      state.appendChild(<mouseMove></mouseMove>);
      currentState = state;
    }
    
    override public function execute(event:Event):void
    {
      super.execute(event);
      
      if(currentState.localName() == event.type)
        notifyBehaviors(event);
    }
  }
}