/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.layout.description
{
    public class TextTransform extends Enum
    {
        public function TextTransform(identifier:String)
        {
            super(identifier);
        }
        
        public static const CAPITALIZE:TextTransform = new TextTransform('capitalize');
        public static const UPPERCASE:TextTransform = new TextTransform('uppercase');
        public static const LOWERCASE:TextTransform = new TextTransform('lowercase');
        public static const NONE:TextTransform = new TextTransform('none');
    }
}

