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
            var j:int = 0;
            var k:int = 0;
            
            var className:String;
            var idName:String;
            var uniqueNodeName:String;
            var inlineStyle:String = 'a:a;';
            var inheritanceStructure:Array = ['global'];
            
            var fStyle:IStyle;
            var str:String = '';
            
            for(i = 0; i < n; i++)
            {
                node = context[i];
                attributes = node.attributes();
                
                if(!(node in nodeCache))
                {
                    k = attributes.length();
                    if(node.localName())
                        str += node.localName();
                    
                    if(k > 0)
                    {
                        //  Math.random() * one billion. reasonably safe for unique identifying...
                        uniqueNodeName = ' node' + String(Math.round(Math.random() * 100000000000));
                        
                        // + "style{"; // + attributes['style'] + "}";
                        for(j = 0; j < k; j++)
                        {
                            attr = attributes[j].name();
                            
                            if(attr == 'class')
                                className = attributes[j];
                            else if(attr == 'id')
                                idName = attributes[j];
                            else if(attr == 'style')
                                inlineStyle += (attributes[i]);
                            else
                                inlineStyle += (attr + ": " + attributes[j] + ";");
                        }
                        
                        if(className)
                            str += " ." + className;
                        if(idName)
                            str += " #" + idName;
                        
                        str += uniqueNodeName;
                        
                        FStyleProxy(style).sheet.parseCSS(uniqueNodeName + "style{" + inlineStyle + "}");
                    }
                    
                    nodeCache[node] = str;
                }
                else
                {
                    str = nodeCache[node];
                }
                
                inheritanceStructure = inheritanceStructure.concat(str.split(' '));
                
                str = '';
                className = '';
                idName = '';
                uniqueNodeName = '';
                inlineStyle = 'a:a;';
            }
            
            fStyle = FStyleProxy(style).sheet.getStyle.apply(null, inheritanceStructure);
            
            var format:ElementFormat = new ElementFormat(
                new FontDescription(
                TypeHelperUtil.getType(fStyle["fontName"] || "_sans", 'string'),
                TypeHelperUtil.getType(fStyle["fontWeight"] || FontWeight.NORMAL, 'string'),
                TypeHelperUtil.getType(fStyle["fontStyle"] || FontPosture.NORMAL, 'string'),
                TypeHelperUtil.getType(fStyle["fontLookup"] || FontLookup.DEVICE, 'string'),
                TypeHelperUtil.getType(fStyle["renderingMode"] || RenderingMode.CFF, 'string'),
                TypeHelperUtil.getType(fStyle["cffHinting"] || CFFHinting.HORIZONTAL_STEM, 'string')
                ),
                TypeHelperUtil.getType(fStyle["fontSize"] || '12', 'int'),
                TypeHelperUtil.getType(fStyle["color"] || '0x0', 'uint'),
                TypeHelperUtil.getType(fStyle["fontAlpha"] || '1', 'number'),
                TypeHelperUtil.getType(fStyle["textRotation"] || TextRotation.AUTO, 'string'),
                TypeHelperUtil.getType(fStyle["dominantBaseLine"] || TextBaseline.ROMAN, 'string'),
                TypeHelperUtil.getType(fStyle["alignmentBaseLine"] || TextBaseline.USE_DOMINANT_BASELINE, 'string'),
                TypeHelperUtil.getType(fStyle["baseLineShift"] || '0.0', 'number'),
                TypeHelperUtil.getType(fStyle["kerning"] || Kerning.ON, 'string'),
                TypeHelperUtil.getType(fStyle["trackingRight"] || '0.0', 'number'),
                TypeHelperUtil.getType(fStyle["trackingLeft"] || '0.0', 'number'),
                TypeHelperUtil.getType(fStyle["locale"] || "en", 'string'),
                TypeHelperUtil.getType(fStyle["breakOpportunity"] || BreakOpportunity.AUTO, 'string'),
                TypeHelperUtil.getType(fStyle["digitCase"] || DigitCase.DEFAULT, 'string'),
                TypeHelperUtil.getType(fStyle["digitWidth"] || DigitWidth.DEFAULT, 'string'),
                TypeHelperUtil.getType(fStyle["ligatureLevel"] || LigatureLevel.COMMON, 'string'),
                TypeHelperUtil.getType(fStyle["typographicCase"] || TypographicCase.DEFAULT, 'string'));
            
            return format;
        }
    }
}


