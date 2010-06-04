package org.tinytlf.decor
{
  import flash.display.Sprite;
  import flash.events.IEventDispatcher;
  import flash.geom.Rectangle;
  
  import org.tinytlf.ITextEngine;
  import org.tinytlf.core.IStyleAware;
  import org.tinytlf.layout.ITextContainer;

  public interface ITextDecoration extends IStyleAware, IEventDispatcher
  {
    function get containers():Vector.<ITextContainer>
    function set containers(textContainers:Vector.<ITextContainer>):void;
    
    function get engine():ITextEngine;
    function set engine(textEngine:ITextEngine):void;
    
    function set styleProxy(proxy:Object):void;
    
    function setup(...args):Vector.<Rectangle>
    
    function draw(bounds:Vector.<Rectangle>):void;
  }
}