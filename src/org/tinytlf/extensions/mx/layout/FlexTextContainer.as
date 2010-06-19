/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.extensions.mx.layout
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.text.engine.TextLine;
    
    import org.tinytlf.extensions.mx.UITextLine;
    
    import org.tinytlf.layout.TextContainerBase;
    
    public class FlexTextContainer extends TextContainerBase
    {
        public function FlexTextContainer(container:DisplayObjectContainer, width:Number = NaN, height:Number = NaN)
        {
            super(container, width, height);
        }
        
        override protected function hookLine(line:TextLine):DisplayObjectContainer
        {
            return new UITextLine(line);
        }
        
        override public function hasLine(line:TextLine):Boolean
        {
            var child:DisplayObject;
            var n:int = target.numChildren;
            
            for(var i:int = 0; i < n; i++)
            {
                child = target.getChildAt(i);
                
                if(child is UITextLine && DisplayObjectContainer(child).contains(line))
                    return true;
            }
            
            return false;
        }
    }
}

