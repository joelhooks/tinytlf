package org.tinytlf.extensions.xhtml.interaction
{
  import flash.events.IEventDispatcher;
  import flash.events.MouseEvent;
  import flash.net.URLRequest;
  import flash.net.navigateToURL;
  import flash.text.engine.ContentElement;
  import flash.ui.Mouse;
  import flash.ui.MouseCursor;
  
  import org.tinytlf.ITextEngine;
  import org.tinytlf.decor.ITextDecor;
  import org.tinytlf.interaction.LineEventInfo;
  import org.tinytlf.interaction.TextDispatcherBase;
  
  public class AnchorInteractor extends TextDispatcherBase
  {
    public function AnchorInteractor(target:IEventDispatcher=null)
    {
      super(target);
    }
    
    override protected function onRollOver(event:MouseEvent):void
    {
      super.onRollOver(event);
      
      Mouse.cursor = MouseCursor.BUTTON;
    }
    
    override protected function onRollOut(event:MouseEvent):void
    {
      super.onRollOut(event);
      
      Mouse.cursor = MouseCursor.ARROW;
    }
    
    override protected function onMouseMove(event:MouseEvent):void
    {
      super.onMouseMove(event);
      
      Mouse.cursor = MouseCursor.BUTTON;
    }
    
    override protected function onClick(event:MouseEvent):void
    {
      super.onClick(event);
      
      if(!allowEvent)
        return;
      
      var info:LineEventInfo = LineEventInfo.getInfo(event, this);
      
      // If the Text Engine is in the middle of rendering lines, info will
      // be null. Don't try to mess w/ stuff while we're rendering :)
      if(!info)
        return;
      
      var engine:ITextEngine = info.engine;
      var element:ContentElement = info.element;
      
      var obj:Object = element.userData
      if(!obj || !('link' in obj))
        return;
      
      navigateToURL(new URLRequest(obj['link']), obj['target'] || '_blank');
    }
  }
}