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
    import flash.utils.Dictionary;
    
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
            var i:int = 0;
            var n:int = _containers.length;
            for(; i < n; i++)
            {
                _containers[i].clear();
            }
        }
        
        public function render(blocks:Vector.<TextBlock>):void
        {
            if(!_containers || !_containers.length)
                throw new Error('ITextLayout needs containers to render on.');
            
            if(!blocks || !blocks.length)
                throw new Error('ITextLayout needs blocks to render. Is your data parsing correctly?');
            
            var blockIndex:int = 0;
            var containerIndex:int = 0;
            
            var block:TextBlock;
            var container:ITextContainer;
            var line:TextLine;
            
            while(blockIndex < blocks.length)
            {
                block = blocks[blockIndex];
                container = _containers[containerIndex];
                
                line = container.layout(block, line);
                
                if(line && ++containerIndex < _containers.length)
                    container = _containers[containerIndex];
                else if(++blockIndex < blocks.length)
                    block = blocks[blockIndex];
                else
                    return;
            }
        }
        
        protected var _containers:Vector.<ITextContainer> = new Vector.<ITextContainer>();
        
        public function get containers():Vector.<ITextContainer>
        {
            return _containers.concat();
        }
        
        public function addContainer(container:ITextContainer):void
        {
            if(_containers.indexOf(container) != -1)
                return;
            
            _containers.push(container);
            container.engine = engine;
        }
        
        public function removeContainer(container:ITextContainer):void
        {
            var i:int = _containers.indexOf(container);
            if(i == -1)
                return;
            
            _containers.splice(i, 1);
            container.engine = null;
        }
        
        public function getContainerForLine(line:TextLine):ITextContainer
        {
            var n:int = _containers.length;
            
            for(var i:int = 0; i < n; i++)
            {
                if(_containers[i].hasLine(line))
                    return _containers[i];
            }
            
            return null;
        }
    }
}

