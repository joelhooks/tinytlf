package org.tiny.tlf.decoration
{
  import flash.display.Shape;
  import flash.geom.Rectangle;

  public interface ITextDecoration
  {
    function set styleName(value:String):void;
    function get styleName():String;
    
    function setup(...args):Vector.<Rectangle>
    
    function draw(shape:Shape, bounds:Vector.<Rectangle>):void;
  }
}