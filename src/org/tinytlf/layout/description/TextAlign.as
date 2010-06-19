/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.layout.description
{
    public class TextAlign extends Enum
    {
        public function TextAlign(identifier:String)
        {
            super(id);
        }
        
        public static const LEFT:TextAlign = new TextAlign("left");
        public static const CENTER:TextAlign = new TextAlign("center");
        public static const RIGHT:TextAlign = new TextAlign("right");
        public static const JUSTIFY:TextAlign = new TextAlign("justify");
    }
}

