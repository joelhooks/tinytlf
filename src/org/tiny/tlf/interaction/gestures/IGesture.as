package org.tiny.tlf.interaction.gestures
{
  import flash.events.Event;
  import flash.events.IEventDispatcher;

  public interface IGesture
  {
    function get target():IEventDispatcher;
    function set target(value:IEventDispatcher):void;
    
    function addBehavior(behavior:IEventDispatcher):void;
    
    function execute(event:Event):void;
  }
}