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
    
    public interface ITextBlockAdapter
    {
        function get engine():ITextEngine;
        function set engine(textEngine:ITextEngine):void;
        
        function execute(content:ContentElement, ...context):TextBlock;
    }
}

