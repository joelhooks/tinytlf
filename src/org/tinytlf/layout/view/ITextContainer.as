package org.tinytlf.layout.view
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
    
    function get allowedWidth():Number;
    function set allowedWidth(value:Number):void;
    
    function get allowedHeight():Number;
    function set allowedHeight(value:Number):void;
    
    function get measuredWidth():Number;
    function get measuredHeight():Number;
    
    function layout(block:TextBlock, line:TextLine):TextLine;
    
    function hasLine(line:TextLine):Boolean;
  }
}