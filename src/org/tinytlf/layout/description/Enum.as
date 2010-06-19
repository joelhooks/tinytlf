/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.layout.description
{
    public class Enum
    {
        public function Enum(identifier:String)
        {
            _id = identifier;
        }
        
        private var _id:String = "";
        public function get id():String
        {
            return _id;
        }
    }
}

