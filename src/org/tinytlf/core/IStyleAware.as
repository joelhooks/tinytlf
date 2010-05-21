package org.tinytlf.core
{
  public interface IStyleAware
  {
    function get styleName():String;
    function set styleName(value:String):void;
    
    function getStyle(styleProp:String):*;
    function setStyle(styleProp:String, newValue:*):void;
  }
}