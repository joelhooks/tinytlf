package org.tiny.tlf
{
  import flash.display.DisplayObjectContainer;
  
  import org.tiny.tlf.block.IBlockFactory;

  public interface ITextContainer
  {
    function get blockFactory():IBlockFactory;
    function set blockFactory(value:IBlockFactory):void;
    
    function get container():DisplayObjectContainer;
    function set container(value:DisplayObjectContainer):void;
    
    function get height():Number;
    function set height(value:Number):void;
    
    function get width():Number;
    function set width(value:Number):void;
    
    function get caretIndex():int;
    function set caretIndex(index:int):void;
    
    function select(...args):void;
    
    function prerender(...args):void;
    
    function invalidate():void;
    function invalidateLines():void;
    function invalidateDecorations():void;
    function invalidateSelection():void;
    
    function render():void;
    function renderLines():void;
    function renderDecorations():void;
    function renderSelection():void;
  }
}