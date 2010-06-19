/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.layout.description
{
    public class TextDirection extends Enum
    {
        public function TextDirection(identifier:String)
        {
            super(identifier);
        }
        
        public static const LTR:TextDirection = new TextDirection("ltr");
        public static const RTL:TextDirection = new TextDirection("rtl");
    }
}

