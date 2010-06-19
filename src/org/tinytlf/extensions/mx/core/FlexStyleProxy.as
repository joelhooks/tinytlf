package org.tinytlf.extensions.mx.core
{
    import mx.core.Singleton;
    import mx.styles.CSSStyleDeclaration;
    import mx.styles.IStyleManager2;
    
    import org.tinytlf.core.StyleAwareActor;
    
    public class FlexStyleProxy extends StyleAwareActor
    {
        public function FlexStyleProxy(styleObject:Object = null)
        {
            super(styleObject);
        }
        
        protected var css:CSSStyleDeclaration;
        
        override public function set style(value:Object):void
        {
            super.style = value;
            
            if(value is String)
            {
                var name:String = String(value);
                if(name.indexOf(".") != 0)
                    name = "." + name;
                
                css = new CSSStyleDeclaration(name);
                for(var s:String in styles)
                    css.setStyle(s, styles[s]);
            }
        }
        
        override public function getStyle(styleProp:String):*
        {
            if(styleProp in styles)
                return styles[styleProp];
            else if(css)
                return css.getStyle(styleProp);
        }
        
        override public function setStyle(styleProp:String, newValue:*):void
        {
            styles[styleProp] = newValue;
            if(css)
                css.setStyle(styleProp, newValue);
        }
        
        protected function get styleManager():IStyleManager2
        {
            return Singleton.getInstance("mx.styles::IStyleManager2") as IStyleManager2;
        }
    }
}

