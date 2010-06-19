/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.layout.adapter
{
    import flash.text.engine.ContentElement;
    import flash.text.engine.TextBlock;
    
    import org.tinytlf.ITextEngine;
    
    public class TextBlockAdapter implements ITextBlockAdapter
    {
        public function execute(content:ContentElement, ...context):TextBlock
        {
            return new TextBlock(content);
        }
        
        private var _engine:ITextEngine;
        
        public function get engine():ITextEngine
        {
            return _engine;
        }
        
        public function set engine(textEngine:ITextEngine):void
        {
            if(textEngine === _engine)
                return;
            
            _engine = textEngine;
        }
    }
}

