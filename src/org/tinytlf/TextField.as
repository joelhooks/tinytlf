package org.tinytlf
{
  import flash.display.DisplayObject;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.EventPhase;
  import flash.text.engine.TextLine;
  
  import org.tinytlf.decor.decorations.BackgroundColorDecoration;
  import org.tinytlf.decor.decorations.StrikeThroughDecoration;
  import org.tinytlf.decor.decorations.UnderlineDecoration;
  import org.tinytlf.extensions.xhtml.interaction.AnchorInteractor;
  import org.tinytlf.extensions.xhtml.layout.adapter.AnchorAdapter;
  import org.tinytlf.extensions.xhtml.layout.adapter.FontAdapter;
  import org.tinytlf.extensions.xml.layout.factory.XMLBlockFactory;
  import org.tinytlf.layout.ITextContainer;
  import org.tinytlf.layout.TextContainerBase;
  
  public class TextField extends Sprite
  {
    public function TextField()
    {
      super();
      
      width = 100;
      height = 100;
      
      hookEngine();
    }
    
    private var _height:Number = 0;
    override public function get height():Number
    {
      return _height;
    }
    
    override public function set height(value:Number):void
    {
      if(!changed(height, value))
        return;
      
      _height = value;
      container.allowedHeight = value;
      engine.invalidate();
    }
    
    private var _width:Number = 0;
    override public function get width():Number
    {
      return _width;
    }
    
    override public function set width(value:Number):void
    {
      if(!changed(width, value))
        return;
      
      _width = value;
      container.allowedWidth = value;
      engine.invalidate();
    }
    
    override public function addChild(child:DisplayObject):DisplayObject
    {
      return super.addChild(child is TextLine ? hookLine(child) : child);
    }
    
    private var _container:ITextContainer;
    
    public function get container():ITextContainer
    {
      if(!_container)
        _container = new TextContainerBase(this);
      
      return _container;
    }
    
    public function set container(textContainer:ITextContainer):void
    {
      if(textContainer == _container)
        return;
      
      _container = textContainer;
      _container.target = this;
    }
    
    private var _engine:ITextEngine;
    
    public function get engine():ITextEngine
    {
      if(!_engine)
      {
        _engine = new TextEngine(stage);
        _engine.blockFactory = new XMLBlockFactory();
        _engine.layout.addContainer(container);
        
        if(!stage)
          addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
      }
      
      return _engine;
    }
    
    public function set engine(textEngine:ITextEngine):void
    {
      if(textEngine == _engine)
        return;
      
      _engine = textEngine;
    }
    
    private var _text:String = "";
    public function set text(value:String):void
    {
      if(!changed(_text, value))
        return;
      
      _text = value;
      engine.blockFactory.data = _text;
      engine.prerender();
      engine.invalidate();
    }
    
    /**
     * @private
     * Called just before a line is added to the display list.
     */
    protected function hookLine(line:DisplayObject):DisplayObject
    {
      return line;
    }
    
    /**
     * @private
     * Called just before rendering of the TextContainer.
     */
    protected function hookEngine():void
    {
      //Default mapped text decorations.
      engine.decor.mapDecoration("backgroundColor", BackgroundColorDecoration);
      engine.decor.mapDecoration("underline", UnderlineDecoration);
      engine.decor.mapDecoration("strikethrough", StrikeThroughDecoration);
      
      engine.blockFactory.mapElementAdapter("a", AnchorAdapter);
      engine.blockFactory.mapElementAdapter("font", FontAdapter);
      
      engine.interactor.mapMirror("a", new AnchorInteractor());
      engine.styler.mapStyle("a", {underline:true});
    }
    
    private function onAddedToStage(event:Event):void
    {
      if(event.eventPhase != EventPhase.AT_TARGET)
        return;
      
      removeEventListener(event.type, onAddedToStage);
      engine.stage = stage;
    }
    
    private function changed(oldVal:*, newVal:*):Boolean
    {
      return Boolean(newVal !== oldVal);
    }
  }
}