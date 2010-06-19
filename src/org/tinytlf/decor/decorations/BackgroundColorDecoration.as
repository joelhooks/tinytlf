/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
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

