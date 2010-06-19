package org.tinytlf.layout.adapter
{
    import flash.text.engine.ContentElement;
    import flash.text.engine.TextBlock;
    
    import org.tinytlf.ITextEngine;
    
    public interface ITextBlockAdapter
    {
        function get engine():ITextEngine;
        function set engine(textEngine:ITextEngine):void;
        
        function execute(content:ContentElement, ...context):TextBlock;
    }
}

