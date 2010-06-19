/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.layout.description
{
    public class TextFloat extends Enum
    {
        public function TextFloat(identifier:String)
        {
            super(identifier);
        }
        
        public static const LEFT:TextFloat = new TextFloat("left");
        public static const RIGHT:TextFloat = new TextFloat("right");
    }
}

