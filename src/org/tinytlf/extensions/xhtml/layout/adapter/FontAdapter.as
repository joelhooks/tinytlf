package org.tinytlf.extensions.xhtml.layout.adapter
{
  import flash.text.engine.ContentElement;
  import flash.text.engine.ElementFormat;
  import flash.text.engine.TextElement;
  
  import org.tinytlf.layout.adapter.ContentElementAdapter;
  
  public class FontAdapter extends ContentElementAdapter
  {
    public function FontAdapter()
    {
      super();
    }
    
    override public function execute(data:Object, ...parameters:Array):ContentElement
    {
      var attr:XMLList = parameters.pop();
      
      var name:String = "";
      if(parameters.length > 0)
        name = parameters.shift();
      
      var element:ContentElement;
      if(data is String)
        element = new TextElement(String(data), null, getEventMirror(name));
      else
        return super.execute.apply(null, [data, name]);
      
      if(!element)
        return null;
      
      if(element)
      {
        var format:ElementFormat = getElementFormat(name);
        var color:uint = attr.(localName() == "color");
        if(color)
          format.color = color;
        var size:Number = attr.(localName() == "size");
        if(size)
          format.fontSize = size;
        
        element.elementFormat = format;
      }
      
      return element;
    }
  }
}