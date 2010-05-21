package org.tinytlf.decor.decorations
{
  import flash.display.Sprite;
  import flash.geom.Rectangle;
  
  import mx.styles.StyleManager;
  import org.tinytlf.decor.TextDecoration;

  public class BackgroundColorDecoration extends TextDecoration
  {
    public function BackgroundColorDecoration(styleName:String = "")
    {
      super(styleName);
    }
    
    override public function draw(parent:Sprite, bounds:Vector.<Rectangle>):void
    {
      super.draw(parent, bounds);
      
      var rect:Rectangle;
      
      while(bounds.length > 0)
      {
        rect = bounds.pop();
        
        parent.graphics.beginFill(getStyle("backgroundColor") || 0x000000, getStyle("backgroundAlpha") || 1);
        parent.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
      }
    }
  }
}