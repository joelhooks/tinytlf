/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.decor.decorations
{
    import flash.geom.Rectangle;
    import org.tinytlf.decor.TextDecoration;
    
    public class CaretDecoration extends TextDecoration
    {
        public function CaretDecoration(styleName:String = "")
        {
            super(styleName);
        }
        
        override public function draw(bounds:Vector.<Rectangle>, layer:int = 0):void
        {
            super.draw(bounds, layer);
        }
    }
}

