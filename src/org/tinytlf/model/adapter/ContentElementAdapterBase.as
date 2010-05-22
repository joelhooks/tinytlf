package org.tinytlf.model.adapter
{
  import flash.events.EventDispatcher;
  import flash.text.engine.ContentElement;
  import flash.text.engine.ElementFormat;
  import flash.text.engine.GroupElement;
  import flash.text.engine.TextElement;
  
  import org.tinytlf.ITextEngine;
  
  public class ContentElementAdapterBase implements IModelAdapter
  {
    public function ContentElementAdapterBase()
    {
    }
    
    public function execute(data:Object, ... context:Array):ContentElement
    {
      var name:String = "";
      
      if(context.length > 0)
        name = context.shift();
      
      var element:ContentElement;
      
      if(data is String)
        element = new TextElement(String(data), getElementFormat(name), getEventMirror(name));
      else if(data is Vector.<ContentElement>)
        element = new GroupElement(Vector.<ContentElement>(data), getElementFormat(name), getEventMirror(name));
      
      if(!element)
        return null;
      
      //Check to see if there's a styleName for this element
      var style:* = engine.styler.getMappedStyle(name);
      if(style)
        engine.decor.decorate(element, null, null, null, 0, style);
      
      return element;
    }
    
    private var _engine:ITextEngine;
    
    public function get engine():ITextEngine
    {
      return _engine;
    }
    
    public function set engine(textEngine:ITextEngine):void
    {
      if(textEngine === _engine)
        return;
      
      _engine = textEngine;
    }
    
    protected function getElementFormat(forName:String):ElementFormat
    {
      if(!_engine)
        return null;
      
      return engine.styler.getElementFormat(forName);
    }
    
    protected function getEventMirror(forName:String):EventDispatcher
    {
      if(!_engine)
        return null;
      
      return engine.interactor.getMirror(forName);
    }
  }
}