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
    
    protected function getElementForNode(node:XML, parentName:String = ""):ContentElement
    {
      if(!node)
        return null;
      
      var adapter:IContentElementAdapter = getElementAdapter(parentName);
      var content:ContentElement;
      
      if(node..*.length() > 1)
      {
        var elements:Vector.<ContentElement> = new Vector.<ContentElement>();
        for each(var child:XML in node.*)
          elements.push(getElementForNode(child, String(node.localName())));
        
        content = adapter.execute(elements, parentName, node.attributes());
      }
      else if(node..*.length() == 1 || node.nodeKind() != 'text')
      {
        adapter = getElementAdapter(node.localName());
        content = adapter.execute(node.text().toString(), node.localName(), node.attributes());
      }
      else
        content = adapter.execute(node.toString(), parentName, node.attributes());
      
      return content;
    }
  }
}