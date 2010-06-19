package org.tinytlf.styles
{
    import flash.text.engine.ElementFormat;
    
    import org.tinytlf.ITextEngine;
    import org.tinytlf.core.IStyleAware;
    
    public interface ITextStyler extends IStyleAware
    {
        function get engine():ITextEngine;
        function set engine(textEngine:ITextEngine):void;
        
        /**
         * Returns an ElementFormat for a given elementName.
         */
        function getElementFormat(element:*):ElementFormat;
        
        function getMappedStyle(element:*):*;
        
        function mapStyle(element:*, value:*):void;
        function unMapStyle(element:*):Boolean;
    }
}

