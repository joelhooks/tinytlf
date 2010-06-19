package org.tinytlf.extensions.fcss.xhtml.core
{
    import com.flashartofwar.fcss.stylesheets.FStyleSheet;
    
    import org.tinytlf.core.StyleAwareActor;
    
    public class FStyleProxy extends StyleAwareActor
    {
        public function FStyleProxy(styleObject:Object=null)
        {
            super(styleObject);
        }
        
        public var sheet:FStyleSheet;
        
        override public function set style(value:Object):void
        {
            if(value is FStyleSheet)
            {
                sheet = FStyleSheet(value);
                return;
            }
            
            super.style = value;
        }
        
        override public function getStyle(styleProp:String):*
        {
            if(styleProp in styles)
                return styles[styleProp];
            else if(sheet)
                return sheet.getStyle(styleProp);
        }
    }
}

