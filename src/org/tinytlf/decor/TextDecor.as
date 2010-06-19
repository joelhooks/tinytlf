package org.tinytlf.decor
{
    import flash.utils.Dictionary;
    
    import org.tinytlf.ITextEngine;
    import org.tinytlf.layout.ITextContainer;
    
    public class TextDecor implements ITextDecor
    {
        public function TextDecor()
        {
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
        
        public function render():void
        {
            var i:int = 0;
            var n:int = layers.length;
            var layer:Dictionary;
            var element:*;
            var decorationProp:String;
            var decoration:ITextDecoration;
            
            for(; i < n; ++i)
            {
                layer = layers[i];
                for(element in layer)
                    for each(decoration in layer[element])
                        if(decoration)
                            decoration.draw(decoration.setup(element), i);
            }
        }
        
        public function removeAll():void
        {
            for(var layer:* in layers)
            {
                for(var element:* in layers[layer])
                {
                    for(var decoration:String in layers[layer][element])
                    {
                        delete layers[layer][element][decoration]
                    }
                    delete layers[layer][element];
                }
                delete layers[layer];
            }
            
            engine.invalidateDecorations();
        }
        
        protected var layers:Array = [];
        
        /**
         * Decorate dresses up an element for presentation. Based on the parameters
         * passed in, he can do many things.
         *
         * This also allows decorations to be drawn to different layers, so you can
         * have decorations that are assured to be at different Z-indicies. 0 is the
         * top most layer, with each increment from 0 -> Infinity on a 'lower' level
         * in the displayList. An object on layer 0 will draw on top of an object at
         * layer 1, etc.
         *
         * One of the simplest use cases is setting a decoration property on an
         * element with a value. So, in order to set a background color of red
         * (assuming there's a decoration mapped for 'backgroundColor'), you would call:
         * #decorate(myElement, 'backgroundColor', 0xFF0000);
         *
         * If, instead of passing a value for the decoration, you want the value to
         * be looked up through styles, you can pass a styleName or style Object with
         * key/value pairs. So, say you had this style:
         *
         * myElementOverStyle {
         *   backgroundColor: #FF0000;
         *   backgroundAlpha: 0.25;
         * }
         *
         * You could call this:
         * #decorate(myElement, 'backgroundColor', null, 0, 'myElementOverStyle');
         *
         * If you don't have a style defined, no worries. Just pass an object with
         * the values:
         * #decorate(myElement, 'backgroundColor', null, 0, {backgroundColor:#FF0000, backgroundAlpha:0.25});
         *
         * This sets the properties in the object as styles on the decoration.
         *
         * Alternatively, you can pass in no decoration property and no value, just a
         * styleName or a key/value Object, and create <code>ITextDecoration</code>
         * instances from the style declaration or values in the Object.
         *
         * I will use this style declaration for reference, but bear in mind that
         * this could just as easily be a key/value paired Object:
         * myElementStyle {
         *   backgroundColor: #FF0000;
         *   backgroundAlpha: 0.25;
         *   underline: true;
         *   underlineColor: #00FF00;
         *   underlineThickness: 4;
         * }
         *
         * Typically backgroundColor and underline exist, so I will use them as an
         * example:
         *
         * We check the list of mapped decoration names against the properties that
         * exist in the style declaration.
         * We see that a 'backgroundColor' property exists, which is mapped to a
         * BackgroundColorDecoration class. So it creates a new instance of the
         * BackgroundColorDecoration class and saddles it with the styleName.
         *
         * Likewise, it would also match the typical 'underline' style up with the
         * UnderlineDecoration class. So he creates an UnderlineDecoration as well,
         * passing the styleName along as well.
         *
         * It's important to note that this, while convenient when creating multiple
         * decorations, doesn't allow you the ability of layering your content any
         * more than 'first-come, first-served.'
         *
         */
        public function decorate(element:*, styleObj:Object, layer:int = 0, container:ITextContainer = null):void
        {
            if(!element || !styleObj)
                return;
            
            //Resolve the layer business first
            var theLayer:Object = resolveLayer(layer);
            if(!(element in theLayer) || theLayer[element] == null)
                theLayer[element] = new Dictionary(true);
            
            //Don't handle parsing a styleName for now, do that in a subclass.
            if(styleObj is String)
                return;
            
            var decoration:ITextDecoration;
            
            var styleProp:String;
            for(styleProp in styleObj)
            {
                if(hasDecoration(styleProp))
                {
                    decoration = ITextDecoration(theLayer[element][styleProp] = getDecoration(styleProp, container));
                    for(styleProp in styleObj)
                        decoration.setStyle(styleProp, styleObj[styleProp]);
                }
            }
            
            engine.invalidateDecorations();
        }
        
        /**
         * Undecorate can completely dress down the element passed in, or it can strip
         * out the decoration for a particular property, leaving the others intact.
         */
        public function undecorate(element:* = null, decorationProp:String = null):void
        {
            var i:int = layers.length - 1;
            var layer:Dictionary;
            
            for(; i >= 0; i--)
            {
                layer = Dictionary(layers[i]);
                
                if(!layer)
                    continue;
                
                if(element)
                {
                    if(!(element in layer) || layer[element] == null)
                        continue;
                    
                    if(!decorationProp)
                        for(var dec:String in layer[element])
                            delete layer[element][dec];
                    else if(decorationProp in layer[element])
                        delete layer[element][decorationProp];
                    
                    if(isEmpty(layer[element]))
                        delete layer[element];
                }
                else if(decorationProp)
                {
                    for(var e:* in layer)
                    {
                        if(layer[e] == null)
                            continue;
                        
                        if(decorationProp in layer[e])
                            delete layer[e][decorationProp];
                        
                        if(isEmpty(layer[e]))
                            delete layer[e];
                    }
                }
            }
            
            engine.invalidateDecorations();
        }
        
        private var decorationsMap:Object = {};
        
        public function mapDecoration(styleProp:String, decorationClassOrInstance:Object):void
        {
            decorationsMap[styleProp] = decorationClassOrInstance;
        }
        
        public function unMapDecoration(styleProp:String):Boolean
        {
            if(!hasDecoration(styleProp))
                return false;
            
            return delete decorationsMap[styleProp];
        }
        
        public function hasDecoration(decorationProp:String):Boolean
        {
            return Boolean(decorationProp in decorationsMap);
        }
        
        public function getDecoration(styleProp:String, container:ITextContainer = null):ITextDecoration
        {
            if(!hasDecoration(styleProp))
                return null;
            
            var decoration:* = decorationsMap[styleProp];
            if(decoration is Class)
                decoration = ITextDecoration(new decoration());
            if(decoration is Function)
                decoration = ITextDecoration((decoration as Function)());
            
            if(!decoration)
                return null;
            
            var vec:Vector.<ITextContainer> = new Vector.<ITextContainer>();
            if(container)
                vec.push(container);
            
            ITextDecoration(decoration).containers = vec;
            
            ITextDecoration(decoration).engine = engine;
            
            return ITextDecoration(decoration);
        }
        
        protected function resolveLayer(layer:int):Dictionary
        {
            if(layer < 0)
                layer = 0;
            // Allow them to use the larger layer, but keep the Array densly populated.
            // This helps with performance, but also solves the bug where a coder really 
            // does want to put something at higher level before other levels are created. 
            // Originally I kept the layers within the bounds of the array, but that
            // introduced race-condition-y scanerios.
            else if(layer > layers.length)
            {
                var i:int = layers.length - 1;
                while(++i < layer)
                    layers[i] = (i in layers) ? layers[i] : null;
            }
            
            if(!(layers[layer]))
                layers[layer] = new Dictionary(true);
            
            return Dictionary(layers[layer]);
        }
        
        private function isEmpty(dict:Object):Boolean
        {
            if(!dict)
                return true;
            
            for(var prop:* in dict)
                if(dict[prop])
                    return false;
            
            return true;
        }
    }
}

