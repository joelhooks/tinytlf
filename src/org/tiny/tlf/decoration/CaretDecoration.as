package org.tiny.tlf.decoration
{
  import flash.display.Shape;
  import flash.geom.Rectangle;

  public class CaretDecoration extends TextDecoration
  {
    public function CaretDecoration(styleName:String="")
    {
      super(styleName);
    }
    
    override public function draw(shape:Shape, bounds:Vector.<Rectangle>):void
    {
      super.draw(shape, bounds);
    }
  }
}