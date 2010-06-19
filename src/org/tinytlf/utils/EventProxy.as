/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.utils
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.EventPhase;
    import flash.events.IEventDispatcher;
    
    public class EventProxy extends EventDispatcher
    {
        private var target:IEventDispatcher;
        private var destination:IEventDispatcher;
        
        public function EventProxy(target:IEventDispatcher,  destination:IEventDispatcher)
        {
            this.target = target;
            this.destination = destination;
        }
        
        public function proxyType(type:String):Boolean
        {
            if(!target)
                return false;
            
            target.addEventListener(type, proxy);
            return true;
        }
        
        public function clearType(type:String):Boolean
        {
            if(!target || !target.hasEventListener(type))
                return false;
            
            target.removeEventListener(type, proxy);
            return true;
        }
        
        private function proxy(event:Event):void
        {
            if(!destination || event.eventPhase != EventPhase.AT_TARGET)
                return;
            
            destination.dispatchEvent(event.clone());
        }
    }
}

