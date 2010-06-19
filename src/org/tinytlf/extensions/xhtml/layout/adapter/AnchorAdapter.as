/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.extensions.xhtml.layout.adapter
{
    import flash.text.engine.ContentElement;
    import flash.text.engine.GroupElement;
    import flash.text.engine.TextElement;
    
    import org.tinytlf.layout.adapter.ContentElementAdapter;
    
    public class AnchorAdapter extends ContentElementAdapter
    {
        public function AnchorAdapter()
        {
            super();
        }
        
        override public function execute(data:Object, ... context:Array):ContentElement
        {
            var element:ContentElement = super.execute.apply(null, [data].concat(context));
            
            if(!element)
                return null;
            
            var anchor:XML;
            if(context.length)
                anchor = context[0];
            
            if(anchor)
            {
                var obj:Object = {};
                obj['link'] = anchor.@href || '';
                obj['target'] = anchor.@target || '';
                element.userData = obj;
            }
            
            return element;
        }
    }
}

