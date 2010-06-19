/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.support
{
    import flash.display.Stage;

    import org.tinytlf.TextEngine;

    public class TextEngineTestable extends TextEngine
    {
        public var linesInvalidated:Boolean;
        public var decorationsInvalidated:Boolean;

        public function TextEngineTestable(stage:Stage)
        {
            super(stage);
        }

        override public function invalidateLines():void
        {
            super.invalidateLines();
            linesInvalidated = _invalidateLinesFlag;
        }

        override public function invalidateDecorations():void
        {
            super.invalidateDecorations();
            decorationsInvalidated = _invalidateDecorationsFlag;
        }
    }
}