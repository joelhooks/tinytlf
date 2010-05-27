package org.tinytlf.layout.model.factory.xml
{
  import flash.text.engine.ContentElement;
  
  import org.tinytlf.layout.model.adapter.IContentElementAdapter;
  import org.tinytlf.layout.model.factory.AbstractBlockFactory;
  
  public class XMLBlockFactory extends AbstractBlockFactory
  {
    public function XMLBlockFactory()
    {
      super();
    }
    
    override public function createElements(... args):Vector.<ContentElement>
    {
      var elements:Vector.<ContentElement> = super.createElements.apply(null, args);
      
      if(!(data is String) && !(data is XML))
        return elements;
      
      elements.push(getElementForNode(XML(data)));
      
      return elements;
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