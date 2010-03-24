package org.tiny.tlf
{
  import flash.display.DisplayObjectContainer;
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.display.Stage;
  import flash.events.Event;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.text.engine.TextBlock;
  import flash.text.engine.TextLine;
  import flash.utils.Dictionary;
  import flash.utils.setTimeout;
  
  import mx.styles.StyleManager;
  
  import org.tiny.tlf.block.IBlockFactory;
  import org.tiny.tlf.block.StandardBlockFactory;
  import org.tiny.tlf.decoration.ITextDecoration;
  
  public class TextContainer implements ITextContainer
  {
    public function TextContainer(container:DisplayObjectContainer = null, width:Number = 100, height:Number = 100)
    {
      this.container = container;
      this.width = width;
      this.height = height;
    }
    
    protected var _blockFactory:IBlockFactory;
    
    public function get blockFactory():IBlockFactory
    {
      if(!_blockFactory)
        _blockFactory = new StandardBlockFactory();
      
      return _blockFactory;
    }
    
    public function set blockFactory(value:IBlockFactory):void
    {
      if(value === _blockFactory)
        return;
      
      _blockFactory = value;
      blockFactory.container = this;
    }
    
    private var _container:DisplayObjectContainer;
    private var lines:Sprite = new Sprite();
    private var shapes:Sprite = new Sprite();
    private var selections:Sprite = new Sprite();
    
    public function get container():DisplayObjectContainer
    {
      return _container;
    }
    
    public function set container(value:DisplayObjectContainer):void
    {
      if(value === _container)
        return;
      
      _container = value;
      
      if(_invalidateStageFlag)
        invalidateStage();
      
      if(selections.parent)
        selections.parent.removeChild(selections);
      if(lines.parent)
        lines.parent.removeChild(lines);
      if(shapes.parent)
        shapes.parent.removeChild(shapes);
      
      container.addChild(shapes);
      container.addChild(lines);
      container.addChild(selections);
      
//      selections.blendMode = BlendMode.INVERT;
      selections.mouseEnabled = false;
      selections.mouseChildren = false;
    }
    
    private var _width:Number = 100;
    
    public function get width():Number
    {
      return _width;
    }
    
    public function set width(value:Number):void
    {
      if(value === _width)
        return;
      
      _width = value;
    }
    
    private var _height:Number = 100;
    
    public function get height():Number
    {
      return _height;
    }
    
    public function set height(value:Number):void
    {
      if(value === _height)
        return;
      
      _height = value;
    }
    
    private var _caretIndex:int = -1;
    public function get caretIndex():int
    {
      return _caretIndex;
    }
    
    public function set caretIndex(index:int):void
    {
      if(index == _caretIndex)
        return;
      
      if(index < 0)
        index = 0;
      
      _caretIndex = index;
      invalidateSelection();
    }
    
    private var selection:Point;
    public function select(... args):void
    {
      if(args.length == 0)
        selection = null;
      else if(args.length == 1)
        selection = new Point(caretIndex || 0, (args[0] is Point) ? pointToIndex(args[0]) : args[0]);
      else if(args.length == 2)
      {
        selection = new Point((args[0] is Point) ? pointToIndex(args[0]) : args[0],
                              (args[1] is Point) ? pointToIndex(args[1]) : args[1]);
      }
      
      invalidateSelection();
    }
    
    protected var blocks:Vector.<TextBlock>;
    
    public function prerender(... args):void
    {
      blockFactory.decorator.flushDecorations();
      blocks = blockFactory.createBlocks(args);
    }
    
    public function invalidate():void
    {
      invalidateLines();
      invalidateDecorations();
      invalidateSelection();
    }
    
    protected var _invalidateLinesFlag:Boolean = false;
    public function invalidateLines():void
    {
      if(_invalidateLinesFlag)
        return;
      
      _invalidateLinesFlag = true;
      invalidateStage();
    }
    
    protected var _invalidateDecorationsFlag:Boolean = false;
    public function invalidateDecorations():void
    {
      if(_invalidateDecorationsFlag)
        return;
      
      _invalidateDecorationsFlag = true;
      invalidateStage();
    }
    
    protected var _invalidateSelectionFlag:Boolean = false;
    public function invalidateSelection():void
    {
      if(_invalidateSelectionFlag)
        return;
      
      _invalidateSelectionFlag = true;
      invalidateStage();
    }
    
    protected var _invalidateStageFlag:Boolean = false;
    protected function invalidateStage():void
    {
      var stage:Stage = container.stage;
      if(!stage)
      {
        _invalidateStageFlag = true;
        return;
      }
      
      stage.addEventListener(Event.RENDER, onRender);
      
      if(_rendering)
        setTimeout(stage.invalidate, 0);
      else
        stage.invalidate();
      
      _invalidateStageFlag = false;
    }
    
    protected var _rendering:Boolean = false;
    protected function onRender(event:Event):void
    {
      _rendering = true;
      
      render();
      
      _rendering = false;
    }
    
    public function render():void
    {
      if(_invalidateLinesFlag)
        renderLines();
      _invalidateLinesFlag = false;
      
      if(_invalidateSelectionFlag)
        renderSelection();
      _invalidateSelectionFlag = false;
      
      if(_invalidateDecorationsFlag)
        renderDecorations();
      _invalidateDecorationsFlag = false;
    }
    
    public function renderLines():void
    {
      if(!blockFactory)
        return;
      
      //If focus is on a line, persist it between renders
      var focusIndex:int = -1;
      while(lines.numChildren > 0)
      {
        if(lines.stage.focus == lines.removeChildAt(lines.numChildren - 1))
          focusIndex = lines.numChildren;
      }
      
      var textBlocks:Vector.<TextBlock> = blocks.concat();
      var block:TextBlock;
      var line:TextLine;
      var lineIndex:int = 0;
      var totalHeight:Number = 0;
      var currentParagraph:int = 0;
      
      while(textBlocks.length > 0)
      {
        block = textBlocks.shift();
        line = block.createTextLine(null, width);
        while(line && totalHeight < height)
        {
          line.userData = this;
          
          totalHeight += line.height;
          
          line.y = totalHeight;
          
          lines.addChild(line);
          
          if(lineIndex == focusIndex)
            lines.stage.focus = line;
          
          line = block.createTextLine(line, width);
          lineIndex++;
        }
        
        currentParagraph++;
      }
      
      if(focusIndex == lineIndex + 1)
        lines.stage.focus = line;
    }
    
    public function renderDecorations():void
    {
      if(!blockFactory)
        return;
      
      while(shapes.numChildren > 0)
        shapes.removeChildAt(0);
      
      var decorations:Dictionary = blockFactory.decorator.getDecorations();
      for(var element:*in decorations)
        for each(var decoration:ITextDecoration in decorations[element])
          decoration.draw(shapes.addChildAt(new Shape(), 0) as Shape, decoration.setup(element));
    }
    
    public function renderSelection():void
    {
      while(selections.numChildren > 0)
        selections.removeChildAt(0);
      
      if(selection != null)
      {
        var decoration:ITextDecoration = blockFactory.decorator.getDecoration("selection");
        var startLine:TextLine = indexToLine(selection.x);
        var endLine:TextLine = indexToLine(selection.y);
        
        decoration.draw(selections.addChildAt(new Shape(), 0) as Shape, decoration.setup(selection, startLine, endLine));
      }
      
      if(caretIndex >= 0)
      {
//        var fontSize:Number = Number(StyleManager.getStyleDeclaration(blockFactory.styler.styleName).getStyle("fontSize")) || 12;
        var cursor:Cursor = new Cursor(12);
        var position:Point = indexToPoint(caretIndex);
        selections.addChild(cursor);
        cursor.x = position.x;
        cursor.y = position.y;
      }
    }
    
    /**
     * @private
     *
     * Returns an index for the given point, assuming the point
     * is relative to the container.
     */
    protected function pointToIndex(point:Point):int
    {
      var line:TextLine;
      var index:int = 0;
      var i:int = 0;
      var n:int = lines.numChildren;
      
      for(i = 0; i < n; i++)
      {
        line = TextLine(lines.getChildAt(i));
        index = line.getAtomIndexAtPoint(point.x, point.y);
        if(index > -1)
          return line.textBlockBeginIndex + index;
      }
      
      return 0;
    }
    
    /**
     * @private
     *
     * Returns a point relative to the container for the given
     * index.
     */
    protected function indexToPoint(index:int):Point
    {
      var bounds:Rectangle;
      var line:TextLine = indexToLine(index);
      
      if(!line)
        return new Point();
      
      bounds = line.getAtomBounds(line.getAtomIndexAtCharIndex(index));
      return new Point(bounds.x + line.x, bounds.y + line.y);
    }
    
    /**
     * @private
     *
     * Returns a TextLine for the given index.
     */
    protected function indexToLine(index:int):TextLine
    {
      var line:TextLine;
      var i:int = 0;
      var n:int = lines.numChildren;
      
      for(i = 0; i < n; i++)
      {
        line = TextLine(lines.getChildAt(i));
        if(index >= line.textBlockBeginIndex && index < (line.textBlockBeginIndex + line.rawTextLength))
          return line;
      }
      
      return null;
    }
  }
}
import flash.display.Shape;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

class Cursor extends Shape
{
  private var timer:Timer;
  private var cursorHeight:Number = 0;
  
  public function Cursor(cursorHeight:Number = 12)
  {
    this.cursorHeight = cursorHeight;
    timer = new Timer(400);
    timer.addEventListener(TimerEvent.TIMER, toggle);
    addEventListener(Event.ADDED_TO_STAGE, added);
    addEventListener(Event.REMOVED_FROM_STAGE, removed);
  }
  
  private function added(event:Event):void
  {
    toggle(null);
    timer.start();
  }
  
  private function removed(event:Event):void
  {
    timer.stop();
    timer.removeEventListener(TimerEvent.TIMER, toggle);
    timer = null;
  }
  
  private var showing:Boolean = false;
  private function toggle(event:TimerEvent):void
  {
    graphics.clear();
    graphics.lineStyle(1, showing ? 0xFFFFFF : 0x000000);
    graphics.moveTo(0, 0);
    graphics.lineTo(0, cursorHeight);
    
    showing = !showing;
  }
}