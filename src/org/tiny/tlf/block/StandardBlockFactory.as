package org.tiny.tlf.block
{
  import flash.events.EventDispatcher;
  import flash.text.engine.ContentElement;
  import flash.text.engine.GroupElement;
  import flash.text.engine.TextElement;
  
  public class StandardBlockFactory extends AbstractBlockFactory
  {
    public function StandardBlockFactory()
    {
      super();
    }
    
    override public function createElements(... args):Vector.<ContentElement>
    {
      var elements:Vector.<ContentElement> = super.createElements.apply(null, args);
      
      if(!(data is String) && !(data is XML))
        return elements;
      
      if(data is String)
        elements.push(new TextElement(data, styler.getElementFormat(), interactor.dispatcher));
      else
      {
        for each(var child:XML in (data as XML).children())
        elements.push(getElementForNode(child));
      }
      
      return elements;
    }
    
    protected function getElementForNode(node:XML):ContentElement
    {
      if(!node)
        return null;
      
      var content:ContentElement;
      if(node.children().length() > 0)
      {
        var elements:Vector.<ContentElement> = new Vector.<ContentElement>();
        for each(var child:XML in node.children())
        {
          elements.push(getElementForNode(child));
        }
        content = new GroupElement(elements, styler.getElementFormat(String(node.localName())), interactor.dispatcher);
      }
      else
        content = new TextElement(data, styler.getElementFormat(String(node.localName())), interactor.dispatcher);
      
      return content;
    }
  }
}