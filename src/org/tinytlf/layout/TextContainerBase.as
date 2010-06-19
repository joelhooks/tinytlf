package org.tinytlf.layout
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.text.engine.LineJustification;
    import flash.text.engine.SpaceJustifier;
    import flash.text.engine.TextBlock;
    import flash.text.engine.TextLine;
    import flash.utils.Dictionary;
    
    import org.tinytlf.ITextEngine;
    import org.tinytlf.layout.description.TextAlign;
    
    public class TextContainerBase implements ITextContainer
    {
        public function TextContainerBase(container:DisplayObjectContainer, allowedWidth:Number = NaN, allowedHeight:Number = NaN)
        {
            this.target = container;
            
            _allowedWidth = allowedWidth;
            _allowedHeight = allowedHeight;
        }
        
        private var _container:DisplayObjectContainer;
        public function get target():DisplayObjectContainer
        {
            return _container;
        }
        
        public function set target(doc:DisplayObjectContainer):void
        {
            if(doc == _container)
                return;
            
            _container = doc;
            
            shapes = Sprite(target.addChild(new Sprite()));
        }
        
        protected var _engine:ITextEngine;
        public function get engine():ITextEngine
        {
            return _engine;
        }
        
        public function set engine(textEngine:ITextEngine):void
        {
            if(textEngine == _engine)
                return;
            
            _engine = textEngine;
        }
        
        private var _shapes:Sprite;
        public function get shapes():Sprite
        {
            return _shapes;
        }
        
        public function set shapes(shapesContainer:Sprite):void
        {
            if(shapesContainer === _shapes)
                return;
            
            var children:Array = [];
            
            if(shapes)
            {
                while(shapes.numChildren)
                    children.push(shapes.removeChildAt(0));
                
                if(shapes.parent && shapes.parent.contains(shapes))
                    shapes.parent.removeChild(shapes);
            }
            
            _shapes = shapesContainer;
            
            while(children.length)
                shapes.addChild(children.shift());
        }
        
        protected var _allowedWidth:Number = NaN;
        
        public function get allowedWidth():Number
        {
            return _allowedWidth;
        }
        
        public function set allowedWidth(value:Number):void
        {
            _allowedWidth = value;
        }
        
        protected var _allowedHeight:Number = NaN;
        
        public function get allowedHeight():Number
        {
            return _allowedHeight;
        }
        
        public function set allowedHeight(value:Number):void
        {
            _allowedHeight = value;
        }
        
        protected var width:Number = 0;
        
        public function get measuredWidth():Number
        {
            return width;
        }
        
        protected var height:Number = 0;
        
        public function get measuredHeight():Number
        {
            return height;
        }
        
        protected var lines:Dictionary = new Dictionary(false);
        
        public function hasLine(line:TextLine):Boolean
        {
            return (line in lines);
        }
        
        public function clear():void
        {
            for(var line:* in lines)
                target.removeChild(line);
            
            height = 0;
        }
        
        public function layout(block:TextBlock, line:TextLine):TextLine
        {
            var doc:DisplayObjectContainer;
            var props:LayoutProperties = getLayoutProperties(block);
            
            height += props.paddingTop;
            
            if(props.textAlign == TextAlign.JUSTIFY)
                block.textJustifier = new SpaceJustifier("en", LineJustification.ALL_BUT_LAST, true);
            
            line = createLine(block, line);
            
            while(line)
            {
                width = allowedWidth;
                
                line.userData = engine;
                
                doc = hookLine(line);
                
                height += doc.height;
                
                doc.y = height;
                
                target.addChild(doc);
                
                height += props.lineHeight;
                
                if(!isNaN(allowedHeight) && measuredHeight > allowedHeight)
                    return line;
                
                line = createLine(block, line);
            }
            
            height += props.paddingBottom;
            
            return line;
        }
        
        protected function createLine(block:TextBlock, line:TextLine = null):TextLine
        {
            var props:LayoutProperties = getLayoutProperties(block);
            
            var w:Number = allowedWidth || props.width;
            var x:Number = 0;
            
            if(line == null)
            {
                w -= props.textIndent;
                x += props.textIndent;
            }
            
            w -= props.paddingLeft;
            w -= props.paddingRight;
            
            line = block.createTextLine(line, w);
            
            if(!line)
                return null;
            
            switch(props.textAlign)
            {
                case TextAlign.LEFT:
                case TextAlign.JUSTIFY:
                    x += props.paddingLeft;
                    break;
                case TextAlign.CENTER:
                    x = (width - line.width) * 0.5;
                    break;
                case TextAlign.RIGHT:
                    x = width - line.width + props.paddingRight;
                    break;
            }
            
            line.x = x;
            
            return line;
        }
        
        protected function hookLine(line:TextLine):DisplayObjectContainer
        {
            lines[line] = true;
            return line;
        }
        
        protected function getLayoutProperties(block:TextBlock):LayoutProperties
        {
            var data:Object = block.userData;
            if(data is LayoutProperties)
                return LayoutProperties(data);
            
            return new LayoutProperties();
        }
    }
}

