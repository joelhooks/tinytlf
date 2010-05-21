package org.tinytlf.layout
{
  import flash.display.DisplayObjectContainer;
  import flash.text.engine.TextBlock;
  import flash.text.engine.TextLine;
  
  import org.tinytlf.ITextEngine;

  public interface ITextContainer
  {
    function get engine():ITextEngine;
    function set engine(textEngine:ITextEngine):void;
    
    function get container():DisplayObjectContainer;
    function set container(textContainer:DisplayObjectContainer):void;
    
    function get shapes():DisplayObjectContainer;
    function set shapes(shapesContainer:DisplayObjectContainer):void;
    
    function get width():Number;
    function set width(value:Number):void;
    
    function get height():Number;
    function set height(value:Number):void;
    
    function layout(block:TextBlock, line:TextLine):TextLine;
    
    function hasLine(line:TextLine):Boolean;
  }
}