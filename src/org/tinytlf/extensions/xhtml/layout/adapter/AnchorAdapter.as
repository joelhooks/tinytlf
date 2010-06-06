package org.tinytlf.extensions.xhtml.layout.adapter
{
  import flash.text.engine.ContentElement;
  import flash.text.engine.GroupElement;
  import flash.text.engine.TextElement;
  
  import org.tinytlf.layout.adapter.ContentElementAdapter;
  
  public class AnchorAdapter extends ContentElementAdapter
  {
    public function AnchorAdapter()
    {
      super();
    }
    
    override public function execute(data:Object, ...parameters:Array):ContentElement
    {
      var attr:XMLList = parameters.pop();
      
      var element:ContentElement = super.execute.apply(null, [data].concat(parameters));
      
      if(!element)
        return null;
      
      if(element)
      {
        var href:String = attr.(localName() == "href");
        if(href)
          engine.styler.mapStyle(element, {link:href});
      }
      
      return element;
    }
  }
}