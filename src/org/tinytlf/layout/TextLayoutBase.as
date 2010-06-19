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
    
    public class TextLayoutBase implements ITextLayout
    {
        protected var _engine:ITextEngine;
        
        public function get engine():ITextEngine
        {
            return _engine;
        }
        
        public function set engine(textEngine:ITextEngine):void
        {
            if(textEngine == _engine)
                return;
            
            _engine = textEngine;
        }
        
        public function clear():void
        {
            for (var i:int = 0; i < containers.length; i++)
            {
                containers[i].clear();
            }
        }

        public function resetShapes():void
        {
            for (var i:int = 0; i < containers.length; i++)
            {
                containers[i].resetShapes();
            }
        }

        public function render(blocks:Vector.<TextBlock>):void
        {
            if(!containers || !containers.length || !blocks || !blocks.length)
                return;
            
            var blockIndex:int = 0;
            var containerIndex:int = 0;
            
            var block:TextBlock;
            var container:ITextContainer;
            var line:TextLine;
            
            while(blockIndex < blocks.length)
            {
                block = blocks[blockIndex];
                container = containers[containerIndex];
                
                line = container.layout(block, line);
                
                if(line && ++containerIndex < containers.length)
                    container = containers[containerIndex];
                else if(++blockIndex < blocks.length)
                    block = blocks[blockIndex];
                else
                    return;
            }
        }
        
        protected var _containers:Vector.<ITextContainer> = new Vector.<ITextContainer>;
        
        public function get containers():Vector.<ITextContainer>
        {
            return _containers ? _containers.concat() : new Vector.<ITextContainer>;
        }
        
        public function addContainer(container:ITextContainer):void
        {
            if(containers.indexOf(container) != -1)
                return;
            
            _containers.push(container);
            container.engine = engine;
        }
        
        public function removeContainer(container:ITextContainer):void
        {
            var i:int = containers.indexOf(container);
            if(i == -1)
                return;
            
            _containers.splice(i, 1);
            container.engine = null;
        }
        
        public function getContainerForLine(line:TextLine):ITextContainer
        {
            var n:int = containers.length;
            
            for(var i:int = 0; i < n; i++)
            {
                if(containers[i].hasLine(line))
                    return containers[i];
            }
            
            return null;
        }
    }
}

