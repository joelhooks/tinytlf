/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.extensions.mx
{
    import flash.display.Stage;
    
    import org.tinytlf.extensions.mx.decor.FlexTextDecor;
    import org.tinytlf.extensions.mx.styles.FlexTextStyler;
    
    import org.tinytlf.TextEngine;
    import org.tinytlf.decor.ITextDecor;
    import org.tinytlf.styles.ITextStyler;
    
    public class FlexTextEngine extends TextEngine
    {
        public function FlexTextEngine(stage:Stage)
        {
            super(stage);
        }
        
        override public function get decor():ITextDecor
        {
            if(!_decor)
                _decor = new FlexTextDecor();
            
            _decor.engine = this;
            
            return _decor;
        }
        
        override public function get styler():ITextStyler
        {
            if(!_styler)
                _styler = new FlexTextStyler();
            
            _styler.engine = this;
            
            return _styler;
        }
    }
}

