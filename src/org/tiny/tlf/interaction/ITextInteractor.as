package org.tiny.tlf.interaction
{
  import flash.events.EventDispatcher;
  import flash.events.IEventDispatcher;
  
  import org.tiny.tlf.block.IBlockFactory;
  import org.tiny.tlf.interaction.gestures.IGesture;

  public interface ITextInteractor extends IEventDispatcher
  {
    function get blockFactory():IBlockFactory;
    function set blockFactory(factory:IBlockFactory):void;
    
    function get dispatcher():EventDispatcher;
    
    function addGesture(gesture:IGesture):void;
  }
}