package org.tiny.tlf.interaction.gestures
{
  import flash.events.Event;
  import flash.events.IEventDispatcher;

  public interface IGesture
  {
    function addBehavior(behavior:IEventDispatcher):void;
    function execute(event:Event):void;
  }
}