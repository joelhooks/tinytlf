package org.tinytlf.decor
{
  import flash.display.Sprite;
  import flash.events.IEventDispatcher;
  import flash.geom.Rectangle;
  
  import org.tinytlf.core.IStyleAware;
  import org.tinytlf.layout.ITextContainer;

  public interface ITextDecoration extends IStyleAware, IEventDispatcher
  {
    function get container():ITextContainer;
    function set container(textContainer:ITextContainer):void;
    
    function set styleProxy(proxy:Object):void;
    
    function setup(...args):Vector.<Rectangle>
    
    function draw(parent:Sprite, bounds:Vector.<Rectangle>):void;
  }
}