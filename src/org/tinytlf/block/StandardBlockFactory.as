package org.tinytlf.block
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
      
      elements.push(getElementForNode(new XML(data)));
      
      return elements;
    }
    
    protected function getElementForNode(node:XML, parentName:String = ""):ContentElement
    {
      if(!node)
        return null;
      
      var content:ContentElement;
      if(node.children().length() > 1)
      {
        var elements:Vector.<ContentElement> = new Vector.<ContentElement>();
        for each(var child:XML in node.children())
        {
          elements.push(getElementForNode(child, String(node.localName())));
        }
        content = new GroupElement(elements, engine.styler.getElementFormat(String(node.localName())), engine.interactor.getMirror(String(node.localName())) as EventDispatcher);
      }
      else if(node.children().length() == 1)
        content = new TextElement(node.text().toString(), engine.styler.getElementFormat(node.localName()), engine.interactor.getMirror(node.localName()) as EventDispatcher);
      else
        content = new TextElement(node.toString(), engine.styler.getElementFormat(parentName), engine.interactor.getMirror(parentName) as EventDispatcher);
      
      return content;
    }
  }
}