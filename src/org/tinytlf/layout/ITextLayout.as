/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.layout
{
    import flash.text.engine.TextBlock;
    import flash.text.engine.TextLine;
    
    import org.tinytlf.ITextEngine;
    
    public interface ITextLayout
    {
        function get engine():ITextEngine;
        function set engine(textEngine:ITextEngine):void;
        
        function get containers():Vector.<ITextContainer>;
        
        function addContainer(container:ITextContainer):void;
        function removeContainer(container:ITextContainer):void;
        
        function getContainerForLine(line:TextLine):ITextContainer;
        
        function clear():void;
        function render(blocks:Vector.<TextBlock>):void;
    }
}

