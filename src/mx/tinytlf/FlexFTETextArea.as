package mx.tinytlf
{
  import flash.display.DisplayObject;
  import flash.text.engine.ContentElement;
  import flash.text.engine.TextBlock;
  import flash.text.engine.TextLine;
  
  import mx.containers.Canvas;
  import mx.core.EdgeMetrics;
  import mx.core.IUIComponent;
  import mx.core.ScrollPolicy;
  import mx.core.mx_internal;
  import mx.tinytlf.layout.FlexTextContainer;
  
  import org.tinytlf.ITextEngine;
  import org.tinytlf.block.IBlockFactory;
  import org.tinytlf.decor.decorations.BackgroundColorDecoration;
  import org.tinytlf.decor.decorations.StrikeThroughDecoration;
  import org.tinytlf.decor.decorations.UnderlineDecoration;
  import org.tinytlf.layout.ITextContainer;
  
  use namespace mx_internal;
  
  public class FlexFTETextArea extends Canvas implements IBlockFactory
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
    
    /*private var _data:Object;
       public function get data():Object
       {
       return _data;
       }
    
       public function set data(value:Object):void
       {
       if(value === _data)
       return;
    
       _data = value;
     }*/
    
    private var _engine:ITextEngine;
    
    public function get engine():ITextEngine
    {
      if(!stage)
        throw new Error('The engine must only be accessed once the component is on the stage.');
      
      if(!_engine)
      {
        _engine = new FlexTextEngine(stage);
        _engine.addContainer(container);
      }
      
      _engine.blockFactory = this;
      
      return _engine;
    }
    
    public function set engine(textEngine:ITextEngine):void
    {
      if(textEngine == _engine)
        return;
      
      _engine = textEngine;
    }
    
    
    protected var _blocks:Vector.<TextBlock> = new Vector.<TextBlock>();
    
    /**
     * Returns a copy of the TextBlocks this IBlockFactory has created.
     */
    public function get blocks():Vector.<TextBlock>
    {
      return _blocks.concat();
    }
    
    protected var _elements:Vector.<ContentElement> = new Vector.<ContentElement>();
    
    /**
     * Returns a copy of the ContentElements this IBlockFactory has created.
     */
    public function get elements():Vector.<ContentElement>
    {
      return _elements.concat();
    }
    
    public function createBlocks(... parameters):Vector.<TextBlock>
    {
      if(_blocks != null)
      {
        var block:TextBlock;
        while(_blocks.length > 0)
        {
          block = _blocks.pop();
          block.releaseLines(block.firstLine, block.lastLine);
        }
      }
      else
      {
        _blocks = new Vector.<TextBlock>();
      }
      
      var elements:Vector.<ContentElement> = createElements.apply(null, parameters);
      
      while(elements.length > 0)
        _blocks.push(hookBlock(new TextBlock(elements.shift())));
      
      return _blocks;
    }
    
    public function createElements(... parameters):Vector.<ContentElement>
    {
      return _elements;
    }
    
    /**
     * @private
     * Called just before the Block is created in createBlocks.
     */
    protected function hookBlock(block:TextBlock):TextBlock
    {
      return block;
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
      
      if(textNeedsRender)
      {
        if((isSizeSpecialCase && isNaN(lastUnscaledWidth)) || isNaN(lastUnscaledWidth))
        {
          invalidateDisplayList();
          return;
        }
        
        // Create the TextBlocks/Render the TextLines.
        var vm:EdgeMetrics = viewMetricsAndPadding;
        var _w:Number = lastUnscaledWidth - vm.left - vm.right;
        _w -= (verticalScrollPolicy == ScrollPolicy.ON || (verticalScrollPolicy == ScrollPolicy.AUTO && verticalScrollBar)) ? verticalScrollBar.getExplicitOrMeasuredWidth() : 0;
        
        container.width = _w;
        
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
  }
}