package org.tiny.tlf.decoration
{
  import flash.display.Shape;
  import flash.geom.Rectangle;

  public class BackgroundColorDecoration extends ElementDecoration
  {
    public function BackgroundColorDecoration(styleName:String = "")
    {
      super(styleName);
    }
    
    override public function draw(shape:Shape, bounds:Vector.<Rectangle>):void
    {
      super.draw(shape, bounds);
      
      var rect:Rectangle;
      
      while(bounds.length > 0)
      {
        rect = bounds.pop();
        
        shape.graphics.beginFill(/*StyleManager.getColorName(getStyle("backgroundColor")) || */0x000000, /*Number(getStyle("backgroundAlpha")) || */1);
        shape.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
      }
    }
  }
}