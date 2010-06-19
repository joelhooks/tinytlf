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
    import com.flashartofwar.fcss.utils.TypeHelperUtil;
    
    import flash.text.engine.*;
    import flash.utils.Dictionary;
    
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
            
            var node:XML;
            var attributes:XMLList;
            var attr:String;
            
            var i:int = 0;
            var n:int = context.length;
            
            var className:String;
            var idName:String;
            var uniqueNodeName:String;
            var inheritanceStructure:Array = ['global'];
            
            var fStyle:IStyle;
            var str:String = '';
            
            for(i = 0; i < n; i++)
            {
                node = context[i];
                
                attributes = node.attributes();
                className = attributes['class'] || '';
                idName = attributes['id'] || '';
                
                if(!(node in nodeCache))
                {
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
                    }
                    
                    nodeCache[node] = true;
                }
                
                if(node.localName())
                    str = node.localName();
                if(className)
                    str += " ." + className;
                if(idName)
                    str += " #" + idName;
                if(uniqueNodeName)
                    str += uniqueNodeName;
                
                inheritanceStructure.push(str);
                
                className = '';
                idName = '';
                uniqueNodeName = '';
            }
            
            fStyle = FStyleProxy(style).sheet.getStyle.apply(null, inheritanceStructure);
            
            var format:ElementFormat = new ElementFormat(
                new FontDescription(
                TypeHelperUtil.getType(fStyle["fontName"] || "_sans", 'string'),
                fStyle["fontWeight"] || FontWeight.NORMAL,
                fStyle["fontStyle"] || FontPosture.NORMAL,
                fStyle["fontLookup"] || FontLookup.DEVICE,
                fStyle["renderingMode"] || RenderingMode.CFF,
                fStyle["cffHinting"] || CFFHinting.HORIZONTAL_STEM
                ),
                fStyle["fontSize"] || 12,
                fStyle["color"] || 0x0,
                fStyle["fontAlpha"] || 1,
                fStyle["textRotation"] || TextRotation.AUTO,
                fStyle["dominantBaseLine"] || TextBaseline.ROMAN,
                fStyle["alignmentBaseLine"] || TextBaseline.USE_DOMINANT_BASELINE,
                fStyle["baseLineShift"] || 0.0,
                fStyle["kerning"] || Kerning.ON,
                fStyle["trackingRight"] || 0.0,
                fStyle["trackingLeft"] || 0.0,
                fStyle["locale"] || "en",
                fStyle["breakOpportunity"] || BreakOpportunity.AUTO,
                fStyle["digitCase"] || DigitCase.DEFAULT,
                fStyle["digitWidth"] || DigitWidth.DEFAULT,
                fStyle["ligatureLevel"] || LigatureLevel.COMMON,
                fStyle["typographicCase"] || TypographicCase.DEFAULT);
            
            return format;
        }
    }
}


