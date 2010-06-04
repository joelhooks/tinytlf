package org.tinytlf.decor.decorations
{
  import flash.display.Sprite;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  
  import org.tinytlf.decor.TextDecoration;
  
  public class UnderlineDecoration extends TextDecoration
  {
    public function UnderlineDecoration(styleName:String = "")
    {
      super();
    }
    
    override public function draw(bounds:Vector.<Rectangle>, layer:int = 0):void
    {
      super.draw(bounds, layer);
      
      var underlineDelta:Number = Math.round((getStyle("fontSize") || 12) / 6);
      var start:Point;
      var end:Point;
      var rect:Rectangle;
      var parent:Sprite;
      
      while(bounds.length > 0)
      {
        rect = bounds.pop();
        parent = spriteMap[rect];
        
        start = new Point(rect.x, rect.y + rect.height - underlineDelta);
        end = new Point(rect.x + rect.width, rect.y + rect.height - underlineDelta);
        
        parent.graphics.lineStyle(
          getStyle("underlineThickness") || 2,
          getStyle("underlineColor") || getStyle("color") || 0x00,
          getStyle("underlineAlpha") || 1,
          getStyle("pixelHinting") || false,
          getStyle("scaleMode") || "normal",
          getStyle("caps") || null,
          getStyle("joints") || null,
          getStyle("miterLimit") || 3);
        
        parent.graphics.moveTo(start.x, start.y);
        parent.graphics.lineTo(end.x, end.y);
      }
    }
  }
}