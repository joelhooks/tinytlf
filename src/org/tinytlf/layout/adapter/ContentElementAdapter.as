/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.layout.adapter
{
    import flash.events.EventDispatcher;
    import flash.text.engine.ContentElement;
    import flash.text.engine.ElementFormat;
    import flash.text.engine.GroupElement;
    import flash.text.engine.TextElement;
    
    import org.tinytlf.ITextEngine;
    
    public class ContentElementAdapter implements IContentElementAdapter
    {
        public function execute(data:Object, ... context:Array):ContentElement
        {
            var element:ContentElement;
            
            var name:String = "";
            
            if(context.length)
                name = context[0].localName();
            
            if(data is String)
                element = new TextElement(String(data), getElementFormat(context), getEventMirror(name));
            else if(data is Vector.<ContentElement>)
                element = new GroupElement(Vector.<ContentElement>(data), getElementFormat(context), getEventMirror(name));
            
            if(!element)
                return null;
            
            //Check to see if there's a styleName for this element
            var style:* = engine.styler.getMappedStyle(name);
            if(style)
                engine.decor.decorate(element, style);
            
            return element;
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
        
        protected function getElementFormat(context:Object):ElementFormat
        {
            // You can't render a textLine with a null ElementFormat, so return an empty one here.
            if(!_engine)
                return new ElementFormat();
            
            return engine.styler.getElementFormat(context);
        }
        
        protected function getEventMirror(forName:String):EventDispatcher
        {
            if(!_engine)
                return null;
            
            return engine.interactor.getMirror(forName);
        }
    }
}

