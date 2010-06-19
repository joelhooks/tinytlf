/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.core
{
    public interface IStyleAware
    {
        function get style():Object;
        function set style(value:Object):void;
        
        function clearStyle(styleProp:String):Boolean;
        function getStyle(styleProp:String):*;
        function setStyle(styleProp:String, newValue:*):void;
    }
}

