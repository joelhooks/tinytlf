/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.decor
{
    import flash.display.Sprite;
    import flash.events.IEventDispatcher;
    import flash.geom.Rectangle;
    
    import org.tinytlf.ITextEngine;
    import org.tinytlf.core.IStyleAware;
    import org.tinytlf.layout.ITextContainer;
    
    public interface ITextDecoration extends IStyleAware, IEventDispatcher
    {
        function get containers():Vector.<ITextContainer>
        function set containers(textContainers:Vector.<ITextContainer>):void;
        
        function get engine():ITextEngine;
        function set engine(textEngine:ITextEngine):void;
        
        function setup(...args):Vector.<Rectangle>
        
        function draw(bounds:Vector.<Rectangle>, layer:int = 0):void;
    }
}

