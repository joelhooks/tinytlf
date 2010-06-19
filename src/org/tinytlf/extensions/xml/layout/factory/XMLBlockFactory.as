/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.extensions.xml.layout.factory
{
    import flash.text.engine.ContentElement;
    
    import org.tinytlf.layout.adapter.IContentElementAdapter;
    import org.tinytlf.layout.factory.AbstractLayoutModelFactory;
    
    public class XMLBlockFactory extends AbstractLayoutModelFactory
    {
        XML.ignoreWhitespace = false;
        
        override public function createElements(... args):Vector.<ContentElement>
        {
            var elements:Vector.<ContentElement> = super.createElements.apply(null, args);
            
            if(!(data is String) && !(data is XML))
                return elements;
            
            var xml:XML = getXML(data);
            if(!xml)
                return elements;
            
            ancestorList = [];
            
            elements.push(getElementForNode(xml));
            
            return elements;
        }
        
        protected function getXML(xmlOrString:Object):XML
        {
            try{
                return XML(xmlOrString);
            }
            catch(e:Error){
                //If we failed the first time, maybe they passed in a string like this:
                // "My string that has <node>nodes</node> without a root."
                try{
                    return new XML("<_>" + xmlOrString + "</_>");
                }
                catch(e:Error){
                    //Do nothing now, we've failed.
                }
            }
            
            return null;
        }
        
        protected var ancestorList:Array;
        
        protected function getElementForNode(node:XML):ContentElement
        {
            if(!node)
                return null;
            
            var parentName:String = node.localName();
            
            if(ancestorList.length)
                parentName = ancestorList[ancestorList.length - 1].localName();
            
            if(node.nodeKind() != "text")
                ancestorList.push(new XML(String(node.toXMLString().match(/\<[^\/](.*?)\>/)[0]).replace('>', '/>')));
            
            var adapter:IContentElementAdapter = getElementAdapter(parentName);
            var content:ContentElement;
            
            if(node..*.length() > 1)
            {
                var elements:Vector.<ContentElement> = new Vector.<ContentElement>();
                for each(var child:XML in node.*)
                    elements.push(getElementForNode(child));
                
                content = adapter.execute.apply(null, [elements].concat(ancestorList));
            }
            else if(node..*.length() == 1 || node.nodeKind() != 'text')
            {
                adapter = getElementAdapter(node.localName());
                content = adapter.execute.apply(null, [node.text().toString()].concat(ancestorList));
            }
            else
                content = adapter.execute.apply(null, [node.toString()].concat(ancestorList));
            
            ancestorList.pop();
            
            return content;
        }
    }
}

