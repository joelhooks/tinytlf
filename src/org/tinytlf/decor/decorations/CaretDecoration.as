package org.tinytlf.decor.decorations
{
  import flash.display.Sprite;
  import flash.geom.Rectangle;
  import org.tinytlf.decor.TextDecoration;
  
  public class CaretDecoration extends TextDecoration
  {
    public function CaretDecoration(styleName:String = "")
    {
      super(styleName);
    }
    
    override public function draw(bounds:Vector.<Rectangle>):void
    {
      super.draw(bounds);
    }
  }
}