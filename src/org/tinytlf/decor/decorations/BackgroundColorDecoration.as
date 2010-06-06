package org.tinytlf.decor.decorations
{
  import flash.display.Sprite;
  import flash.geom.Rectangle;
  
  import org.tinytlf.decor.TextDecoration;

  public class BackgroundColorDecoration extends TextDecoration
  {
    public function BackgroundColorDecoration(styleName:String = "")
    {
      super(styleName);
    }
    
    override public function draw(bounds:Vector.<Rectangle>, layer:int = 0):void
    {
      super.draw(bounds, layer);
      
      var rect:Rectangle;
      var parent:Sprite;
      
      while(bounds.length > 0)
      {
        rect = bounds.pop();
        parent = spriteMap[rect];
        if(!parent)
          return;
        
        parent.graphics.beginFill(getStyle("backgroundColor") || 0x000000, getStyle("backgroundAlpha") || 1);
        parent.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
      }
    }
  }
}