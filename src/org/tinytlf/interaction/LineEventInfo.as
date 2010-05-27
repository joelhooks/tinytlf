package org.tinytlf.interaction
{
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.text.engine.ContentElement;
  import flash.text.engine.TextLine;
  import flash.text.engine.TextLineMirrorRegion;
  import flash.text.engine.TextLineValidity;
  
  import mx.tinytlf.UITextLine;
  
  import org.tinytlf.ITextEngine;
  import org.tinytlf.layout.view.ITextContainer;
  import org.tinytlf.utils.FTEUtil;

  public class LineEventInfo
  {
    public static function getInfo(event:Event, eventMirror:EventDispatcher = null):LineEventInfo
    {
      var target:Object = event.target;
      var canProcess:Boolean = (target is TextLine) || (target is UITextLine);
      
      if(!canProcess)
        return null;
      
      var line:TextLine = (target as TextLine) || UITextLine(target).line;
      
      if(line.validity == TextLineValidity.INVALID)
        return null;
      
      var index:int = line.textBlockBeginIndex;
      
      if(event is MouseEvent)
        index = FTEUtil.getAtomIndexAtPoint(MouseEvent(event).stageX, MouseEvent(event).stageY, line);
      
      var element:ContentElement = FTEUtil.getContentElementAt(line.textBlock.content, index);
      var mirrorRegion:TextLineMirrorRegion = line.getMirrorRegion(eventMirror || element.eventMirror);
      
      return new LineEventInfo(line, line.userData, mirrorRegion, mirrorRegion != null ? mirrorRegion.element : element, (line.parent as UITextLine) || (target as UITextLine));
    }
    
    public function LineEventInfo(line:TextLine, engine:ITextEngine, mirrorRegion:TextLineMirrorRegion, element:ContentElement, uiTextLine:UITextLine)
    {
      _engine = engine;
      _element = element;
      _line = line;
      _mirrorRegion = mirrorRegion;
      _container = engine.layout.getContainerForLine(line);
      _uiLine = uiTextLine;
    }
    
    private var _container:ITextContainer;
    public function get container():ITextContainer
    {
      return _container;
    }
    
    private var _engine:ITextEngine;
    public function get engine():ITextEngine
    {
      return _engine;
    }
    
    private var _element:ContentElement;
    public function get element():ContentElement
    {
      return _element;
    }
    
    private var _uiLine:UITextLine;
    public function get uiTextLineline():UITextLine
    {
      return _uiLine;
    }
    
    private var _line:TextLine;
    public function get line():TextLine
    {
      return _line;
    }
    
    private var _mirrorRegion:TextLineMirrorRegion;
    public function get mirrorRegion():TextLineMirrorRegion
    {
      return _mirrorRegion;
    }
  }
}