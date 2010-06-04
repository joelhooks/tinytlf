package org.tinytlf.decor
{
  import org.tinytlf.ITextEngine;
  import org.tinytlf.layout.ITextContainer;

  public interface ITextDecor
  {
    function get engine():ITextEngine;
    function set engine(textEngine:ITextEngine):void;
    
    function render():void;
    
    function removeAll():void;
    
    function decorate(element:*, styleObj:Object, layer:int = 0, container:ITextContainer = null):void;
    function undecorate(element:* = null, decorationProp:String = null):void;
    
    function mapDecoration(decorationProp:String, decorationClassOrInstance:Object):void;
    function unMapDecoration(decorationProp:String):Boolean;
    function hasDecoration(decorationProp:String):Boolean;
    function getDecoration(decorationProp:String, container:ITextContainer = null):ITextDecoration;
  }
}