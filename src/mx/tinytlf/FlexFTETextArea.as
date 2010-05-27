package mx.tinytlf
{
  import flash.display.DisplayObject;
  import flash.events.Event;
  import flash.text.engine.TextLine;
  
  import mx.containers.Canvas;
  import mx.core.EdgeMetrics;
  import mx.core.IUIComponent;
  import mx.core.ScrollPolicy;
  import mx.core.mx_internal;
  import mx.tinytlf.layout.FlexTextContainer;
  
  import org.tinytlf.ITextEngine;
  import org.tinytlf.decor.decorations.BackgroundColorDecoration;
  import org.tinytlf.decor.decorations.StrikeThroughDecoration;
  import org.tinytlf.decor.decorations.UnderlineDecoration;
  import org.tinytlf.layout.view.ITextContainer;
  
  use namespace mx_internal;
  
  public class FlexFTETextArea extends Canvas
  {
    public function FlexFTETextArea()
    {
      super();
      
      minWidth = 100;
      minHeight = 100;
    }
    
    private var _container:ITextContainer;
    
    public function get container():ITextContainer
    {
      if(!_container)
        _container = new FlexTextContainer(this);
      
      return _container;
    }
    
    public function set container(textContainer:ITextContainer):void
    {
      if(textContainer == _container)
        return;
      
      _container = textContainer;
      _container.container = this;
    }
    
    override public function set data(value:Object):void
    {
      var changed:Boolean = (value !== super.data);
      super.data = value;
      if(changed)
      {
        textNeedsRender = true;
        invalidateProperties();
      }
    }
    
    private var _engine:ITextEngine;
    
    public function get engine():ITextEngine
    {
      if(!stage)
        throw new Error('The engine can only be accessed once the FlexFTETextArea is on the stage.');
      
      if(!_engine)
      {
        _engine = new FlexTextEngine(stage);
        _engine.layout.addContainer(container);
      }
      
      return _engine;
    }
    
    public function set engine(textEngine:ITextEngine):void
    {
      if(textEngine == _engine)
        return;
      
      _engine = textEngine;
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
      if(styleName is String)
        engine.styler.styleName = String(styleName);
      
      //Default mapped text decorations.
      engine.decor.mapDecoration("backgroundColor", BackgroundColorDecoration);
      engine.decor.mapDecoration("underline", UnderlineDecoration);
      engine.decor.mapDecoration("strikethrough", StrikeThroughDecoration);
    }
    
    protected function renderText():void
    {
      hookEngine();
      engine.prerender();
      engine.invalidate();
      engine.render();
    }
    
    override public function addChildAt(child:DisplayObject, index:int):DisplayObject
    {
      if(child is IUIComponent)
        return super.addChildAt(child is UITextLine ? hookLine(child) : child, index);
      
      return rawChildren_addChildAt(child is TextLine ? hookLine(child) : child, index);
    }
    
    protected var textNeedsRender:Boolean = false;
    
    override protected function commitProperties():void
    {
      super.commitProperties();
      
      if(!stage && textNeedsRender)
      {
        textNeedsRender = true;
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        return;
      }
      
      if(textNeedsRender)
      {
        if(isSizeSpecialCase && isNaN(lastUnscaledWidth))
        {
          invalidateDisplayList();
          return;
        }
        
        // Create the TextBlocks/Render the TextLines.
        var vm:EdgeMetrics = viewMetricsAndPadding;
        var w:Number = lastUnscaledWidth - vm.left - vm.right;
        w -= (verticalScrollPolicy == ScrollPolicy.ON || (verticalScrollPolicy == ScrollPolicy.AUTO && verticalScrollBar)) ?
          verticalScrollBar.getExplicitOrMeasuredWidth() : 0;
        
        container.allowedWidth = w;
        
        engine.blockFactory.data = data;
        
        renderText();
        
        invalidateSize();
        invalidateDisplayList();
        
        textNeedsRender = false;
      }
    }
    
    protected var lastUnscaledWidth:Number = NaN;
    
    override protected function updateDisplayList(w:Number, h:Number):void
    {
      if(isSizeSpecialCase)
      {
        var firstTime:Boolean = isNaN(lastUnscaledWidth) || lastUnscaledWidth != w;
        lastUnscaledWidth = w;
        if(firstTime)
        {
          invalidateProperties();
          return;
        }
      }
      
      lastUnscaledWidth = w;
      
      if(textNeedsRender)
        invalidateProperties();
      
      super.updateDisplayList(w, h);
    }
    
    /**
     *  @private
     *  The cases that requires a second pass through the LayoutManager
     *  are <PassageDisplay width="N%"/> (the control is to use the percentWidth
     *  but the measuredHeight) and <PassageDisplay left="N" right="N"/>
     *  (the control is to use the parent's width minus the constraints
     *  but the measuredHeight).
     */
    protected function get isSizeSpecialCase():Boolean
    {
      var left:Number = getStyle("left");
      var right:Number = getStyle("right");
      
      return (!isNaN(percentWidth) || (!isNaN(left) && !isNaN(right))) && isNaN(explicitHeight) && isNaN(percentHeight);
    }
    
    protected function onAddedToStage(event:Event):void
    {
      removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
      
      if(textNeedsRender)
        invalidateProperties();
    }
  }
}