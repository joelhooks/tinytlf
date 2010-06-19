package org.tinytlf.extensions.mx
{
    import flash.display.Graphics;
    import flash.text.engine.TextLine;
    
    import mx.core.UIComponent;
    
    public class UITextLine extends UIComponent
    {
        public function UITextLine(line:TextLine = null)
        {
            this.line = line;
        }
        
        private var _line:TextLine;
        public function get line():TextLine
        {
            return _line;
        }
        
        public function set line(value:TextLine):void
        {
            if(value === _line)
                return;
            
            if(line)
                uninstallLine(line);
            
            _line = value;
            
            if(line)
                installLine(line);
        }
        
        protected function installLine(line:TextLine):void
        {
            width = line.width;
            line.y = height = line.height;
            
            addChild(line);
        }
        
        protected function uninstallLine(line:TextLine):void
        {
            if(contains(line))
                removeChild(line);
            
            graphics.clear();
        }
        
        override protected function updateDisplayList(w:Number, h:Number):void
        {
            super.updateDisplayList(w, h);
            
            // Draw a mouse catcher behind the TextLine so we can catch and proxy the 
            // "roll" events.
            var g:Graphics = graphics;
            g.clear();
            g.beginFill(0x00, 0);
            g.drawRect(line.x, 5, w, h);
        }
    }
}

