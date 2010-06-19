/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.extensions.fcss.xhtml.styles
{
    import com.flashartofwar.fcss.styles.IStyle;
    import com.flashartofwar.fcss.stylesheets.FStyleSheet;
    import com.flashartofwar.fcss.stylesheets.IStyleSheet;
    
    import flash.text.engine.ElementFormat;
    import flash.utils.Dictionary;
    
    import org.tinytlf.decor.decorations.StrikeThroughDecoration;
    import org.tinytlf.extensions.fcss.xhtml.core.FStyleProxy;
    import org.tinytlf.styles.TextStyler;
    
    public class FCSSTextStyler extends TextStyler
    {
        override public function set style(value:Object):void
        {
            var sheet:FStyleSheet = new FStyleSheet();
            sheet.parseCSS(value as String);
            super.style = new FStyleProxy(sheet);
        }
        
        private var nodeCache:Dictionary = new Dictionary(true);
        
        override public function getElementFormat(element:*):ElementFormat
        {
            if(!(element is Array) || !(style is FStyleProxy))
                return super.getElementFormat(element);
            
            //  Context is an array of XML nodes, the currently processing
            //  node and its parents, along with all their attributes.
            var context:Array = (element as Array);
            var format:ElementFormat = new ElementFormat();
            
            var node:XML;
            var attributes:XMLList;
            var attr:String;
            
            var i:int = 0;
            var n:int = context.length;
            
            var className:String;
            var idName:String;
            var uniqueNodeName:String;
            var inheritanceStructure:String = '';
            
            var fStyle:IStyle;
            
            for(i = 0; i < n; i++)
            {
                node = context[i];
                
                attributes = node.attributes();
                className = attributes['class'] || '';
                idName = attributes['id'] || '';
                
                if(!(node in nodeCache))
                {
                    var str:String = '';
                    if(node.localName())
                        str += node.localName();
                    if(className)
                        str += " ." + className;
                    if(idName)
                        str += " #" + idName;
                    
                    if(attributes.length() > 0)
                    {
                        //  Math.random() * one billion. reasonably safe for unique identifying...
                        uniqueNodeName = ' node' + String(Math.random() * 100000000000) + "style{";// + attributes['style'] + "}";
                        for(attr in attributes)
                        {
                            if(attr == 'class' || attr == 'id')
                                continue;
                            
                            uniqueNodeName += (attr == 'style') ? attributes[attr] : (attr + ": " + attributes[attr] + ";");
                        }
                        uniqueNodeName += "}";
                    }
                    if(uniqueNodeName)
                        str += uniqueNodeName;
                    
                    FStyleProxy(style).sheet.parseCSS(str);
                    fStyle = getStyle(str);
                    nodeCache[node] = fStyle;
                }
                
                if(node.localName())
                    inheritanceStructure += ' ' + node.localName();
                if(className)
                    inheritanceStructure += " ." + className;
                if(idName)
                    inheritanceStructure += " #" + idName;
                if(uniqueNodeName)
                    inheritanceStructure += uniqueNodeName;
                
                className = '';
                idName = '';
                uniqueNodeName = '';
            }
            
            fStyle = getStyle(inheritanceStructure);
            for(attr in fStyle)
            {
                if(attr in format)
                    format[attr] = fStyle[attr];
            }
            
            return format;
        }
    }
}


