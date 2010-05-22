package org.tinytlf.model.factory.xml
{
  import flash.events.EventDispatcher;
  import flash.text.engine.ContentElement;
  import flash.text.engine.GroupElement;
  import flash.text.engine.TextElement;
  
  import org.tinytlf.model.adapter.IModelAdapter;
  import org.tinytlf.model.factory.AbstractBlockFactory;
  
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
      
      elements.push(getElementForNode(new XML(data)));
      
      return elements;
    }
    
    protected function getElementForNode(node:XML, parentName:String = ""):ContentElement
    {
      if(!node)
        return null;
      
      var adapter:IModelAdapter = getModelAdapter(parentName);
      var content:ContentElement;
      
      if(node.descendants().length() > 1)
      {
        var elements:Vector.<ContentElement> = new Vector.<ContentElement>();
        for each(var child:XML in node.children())
        {
          elements.push(getElementForNode(child, String(node.localName())));
        }
        
        content = adapter.execute(elements, parentName, node.attributes());
      }
      else if(node.descendants().length() == 1)
      {
        adapter = getModelAdapter(node.localName());
        content = adapter.execute(node.text().toString(), node.localName(), node.attributes());
      }
      else
        content = adapter.execute(node.toString(), parentName, node.attributes());
      
      return content;
    }
  }
}