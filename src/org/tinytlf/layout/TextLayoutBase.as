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
            var i:int = 0;
            var n:int = _containers.length;
            for(; i < n; i++)
            {
                _containers[i].clear();
            }
        }

        public function resetShapes():void
        {
            var containers:Vector.<ITextContainer> = containers;
            var i:int;
            var n:int;

            if(containers)
                n = containers.length;
            else
                return;

            for (i = 0; i < n; i++)
            {
                var container:ITextContainer = containers[i] as ITextContainer;
                container.resetShapes();
            }
        }

        public function render(blocks:Vector.<TextBlock>):void
        {
            if(!_containers || !_containers.length || !blocks || !blocks.length)
                return;
            
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
            return _containers ? _containers.concat() : new Vector.<ITextContainer>;
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

