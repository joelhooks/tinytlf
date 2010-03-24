package org.tiny.tlf.interaction.gestures
{
  import flash.events.Event;

  public class MouseOutGesture extends GestureBase
  {
    public function MouseOutGesture()
    {
      state.appendChild(<mouseOut></mouseOut>);
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