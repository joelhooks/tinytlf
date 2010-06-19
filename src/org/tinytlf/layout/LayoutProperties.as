/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.layout
{
    import org.tinytlf.layout.description.TextAlign;
    import org.tinytlf.layout.description.TextDirection;
    import org.tinytlf.layout.description.TextFloat;
    import org.tinytlf.layout.description.TextTransform;
    
    public class LayoutProperties
    {
        public function LayoutProperties(props:Object = null)
        {
            if(!props)
                return;
            
            for(var prop:String in props)
            {
                if(prop in this)
                    this[prop] = props[prop]
            }
        }
        
        public var associatedItem:*;
        
        public var width:Number = 0;
        public var lineHeight:Number = 0;
        public var textIndent:Number = 0;
        public var paddingLeft:Number = 0;
        public var paddingRight:Number = 0;
        public var paddingBottom:Number = 0;
        public var paddingTop:Number = 0;
        
        public var textAlign:TextAlign = TextAlign.LEFT;
        public var textDirection:TextDirection = TextDirection.LTR;
        public var textTransform:TextTransform = TextTransform.NONE;
        public var float:TextFloat = TextFloat.LEFT;
    }
}

