package org.tiny.tlf.interaction
{
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.text.engine.ContentElement;
  import flash.text.engine.TextLine;
  import flash.text.engine.TextLineMirrorRegion;
  import flash.text.engine.TextLineValidity;
  
  import org.tiny.tlf.ITextContainer;
  import org.tiny.tlf.utils.FTEUtil;

  public class LineInfo
  {
    public static function getInfo(event:Event, eventMirror:EventDispatcher = null):LineInfo
    {
      if(!(event.currentTarget is TextLine) && !(event.target is TextLine))
        return null;
      
      var line:TextLine = (event.currentTarget as TextLine) || (event.target as TextLine);
      
      if(line.validity == TextLineValidity.INVALID)
        return null;
      
      var index:int = line.textBlockBeginIndex;
      
      if(event is MouseEvent)
        index = FTEUtil.getAtomIndexAtPoint(MouseEvent(event).stageX, MouseEvent(event).stageY, line);
      
      var element:ContentElement = FTEUtil.getContentElementAt(line.textBlock.content, index);
      var mirrorRegion:TextLineMirrorRegion = line.getMirrorRegion(eventMirror || element.eventMirror);
      
      return new LineInfo(line, line.userData, mirrorRegion, mirrorRegion != null ? mirrorRegion.element : element);
    }
    
    public function LineInfo(line:TextLine, container:ITextContainer, mirrorRegion:TextLineMirrorRegion, element:ContentElement)
    {
      _container = container;
      _element = element;
      _line = line;
      _mirrorRegion = mirrorRegion;
    }
    
    protected var _container:ITextContainer;
    public function get container():ITextContainer
    {
      return _container;
    }
    
    protected var _element:ContentElement;
    public function get element():ContentElement
    {
      return _element;
    }
    
    protected var _line:TextLine;
    public function get line():TextLine
    {
      return _line;
    }
    
    protected var _mirrorRegion:TextLineMirrorRegion;
    public function get mirrorRegion():TextLineMirrorRegion
    {
      return _mirrorRegion;
    }
  }
}