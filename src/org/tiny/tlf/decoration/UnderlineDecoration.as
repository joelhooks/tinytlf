package org.tiny.tlf.decoration
{
  import flash.display.Shape;
  import flash.geom.Point;
  import flash.geom.Rectangle;

  public class UnderlineDecoration extends ElementDecoration
  {
    public function UnderlineDecoration(styleName:String = "")
    {
      super(styleName);
    }
    
    override public function draw(shape:Shape, bounds:Vector.<Rectangle>):void
    {
      super.draw(shape, bounds);
      
      var underlineDelta:Number = Math.round((getStyle("fontSize") || 12) / 6);
      var start:Point;
      var end:Point;
      var rect:Rectangle;
      
      while(bounds.length > 0)
      {
        rect = bounds.pop();
        
        start = new Point(rect.x, rect.y + rect.height - underlineDelta);
        end   = new Point(rect.x + rect.width, rect.y + rect.height - underlineDelta);
      
        shape.graphics.lineStyle(getStyle("underlineThickness") || 2, getStyle("fontColor") || 0x00, getStyle("underlineAlpha") || 1);
        shape.graphics.moveTo(start.x, start.y);
        shape.graphics.lineTo(end.x, end.y);
      }
    }
  }
}