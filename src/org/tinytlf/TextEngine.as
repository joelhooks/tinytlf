package org.tinytlf
{
  import flash.display.DisplayObjectContainer;
  import flash.display.Shape;
  import flash.display.Stage;
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.text.engine.TextBlock;
  import flash.text.engine.TextLine;
  import flash.utils.setTimeout;
  
  import org.tinytlf.block.AbstractBlockFactory;
  import org.tinytlf.block.IBlockFactory;
  import org.tinytlf.decor.ITextDecor;
  import org.tinytlf.decor.TextDecor;
  import org.tinytlf.interaction.ITextInteractor;
  import org.tinytlf.interaction.TextInteractorBase;
  import org.tinytlf.layout.ITextContainer;
  import org.tinytlf.layout.ITextLayout;
  import org.tinytlf.layout.TextLayoutBase;
  import org.tinytlf.styles.ITextStyler;
  import org.tinytlf.styles.TextStyler;
  
  public class TextEngine extends EventDispatcher implements ITextEngine
  {
    protected var stage:Stage;
    public function TextEngine(stage:Stage)
    {
      this.stage = stage;
    }
    
    protected var _blockFactory:IBlockFactory;
    
    public function get blockFactory():IBlockFactory
    {
      if(!_blockFactory)
        _blockFactory = new AbstractBlockFactory();
      
      return _blockFactory;
    }
    
    public function set blockFactory(value:IBlockFactory):void
    {
      if(value === _blockFactory)
        return;
      
      _blockFactory = value;
      
      blockFactory.engine = this;
    }
    
    protected var _decor:ITextDecor;
    public function get decor():ITextDecor
    {
      if(!_decor)
        _decor = new TextDecor();
      
      _decor.engine = this;
      
      return _decor;
    }
    
    public function set decor(textDecor:ITextDecor):void
    {
      if(textDecor == _decor)
        return;
      
      _decor = textDecor;
    }
    
    protected var _interactor:ITextInteractor;
    public function get interactor():ITextInteractor
    {
      if(!_interactor)
        _interactor = new TextInteractorBase();
      
      _interactor.engine = this;
      
      return _interactor;
    }
    
    public function set interactor(textInteractor:ITextInteractor):void
    {
      if(textInteractor == _interactor)
        return;
      
      _interactor = textInteractor;
    }
    
    protected var _layout:ITextLayout;
    public function get layout():ITextLayout
    {
      if(!_layout)
        _layout = new TextLayoutBase();
      
      _layout.engine = this;
      
      return _layout;
    }
    
    public function set layout(textLayout:ITextLayout):void
    {
      if(textLayout == _layout)
        return;
      
      _layout = textLayout;
    }
    
    protected var _styler:ITextStyler;
    public function get styler():ITextStyler
    {
      if(!_styler)
        _styler = new TextStyler();
      
      _styler.engine = this;
      
      return _styler;
    }
    
    public function set styler(textStyler:ITextStyler):void
    {
      if(textStyler == _styler)
        return;
      
      _styler = textStyler;
    }
    
    private var containers:Vector.<ITextContainer> = new Vector.<ITextContainer>();
    public function addContainer(container:ITextContainer):void
    {
      if(containers.indexOf(container) != -1)
        return;
      
      containers.push(container);
      container.engine = this;
    }
    
    public function removeContainer(container:ITextContainer):void
    {
      var i:int = containers.indexOf(container);
      if(i == -1)
        return;
      
      containers.splice(i, 1);
      container.engine = null;
    }
    
    protected var blocks:Vector.<TextBlock>;
    
    public function prerender(... args):void
    {
      decor.removeAll();
      blocks = blockFactory.createBlocks(args);
    }
    
    public function invalidate():void
    {
      invalidateLines();
      invalidateDecorations();
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
    
    protected var _invalidateStageFlag:Boolean = false;
    protected function invalidateStage():void
    {
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
      if(!stage)
      {
        return;
      }
      
      stage.removeEventListener(Event.RENDER, onRender);
      
      _rendering = true;
      
      render();
      
      _rendering = false;
    }
    
    public function render():void
    {
      if(_invalidateLinesFlag)
        renderLines();
      _invalidateLinesFlag = false;
      
      if(_invalidateDecorationsFlag)
        renderDecorations();
      _invalidateDecorationsFlag = false;
    }
    
    public function renderLines():void
    {
      layout.render(blockFactory.blocks, containers);
      /*
      //If focus is on a line, persist it between renders
      var focusIndex:int = -1;
      var totalChildren:int = container.numChildren;
      
      while(totalChildren > 0)
      {
        var currChild:DisplayObject = container.getChildAt(--totalChildren);
        
        if(!(currChild is TextLine))
          continue;
        
        if(container.stage && container.stage.focus == currChild)
          focusIndex = container.numChildren - 2;

        container.removeChild(currChild);
      }
      
      var textBlocks:Vector.<TextBlock> = blockFactory.blocks;
      var block:TextBlock;
      var line:TextLine;
      var lineIndex:int = 0;
      var totalHeight:Number = 0;
      var currentParagraph:int = 0;
      
      while(textBlocks.length > 0)
      {
        block = textBlocks.shift();
        line = block.createTextLine(null, width);
        while(line)
        {
          line.userData = this;
          
          totalHeight += line.height;
          
          line.y = totalHeight;
          
          container.addChild(line);
          
          if(lineIndex == focusIndex)
            container.stage.focus = line;
          
          executeLineHooks(line);
          
          line = block.createTextLine(line, width);
          lineIndex++;
          
          if(!isNaN(height) && totalHeight > height)
            break;
        }
        
        totalHeight += 16;
        currentParagraph++;
      }
      
      _textHeight = totalHeight;
      
      if(focusIndex == lineIndex + 1)
        container.stage.focus = line;
      */
    }
    
    public function renderDecorations():void
    {
      var i:int = 0;
      var n:int = containers.length;
      var doc:DisplayObjectContainer;
      
      for(; i < n; i++)
      {
        doc = containers[i].shapes;
        while(doc && doc.numChildren)
          doc.removeChildAt(0);
      }
      
      decor.render();
    }
    
    public function getContainerForLine(line:TextLine):ITextContainer
    {
      var n:int = containers.length;
      
      for(var i:int = 0; i < n; i++)
      {
        if(containers[i].hasLine(line))
          return containers[i];
      }
      
      return null;
    }
    
    /*
    public function renderSelection():void
    {
      while(selections.numChildren > 0)
        selections.removeChildAt(0);
      
      if(selection != null)
      {
        var decoration:ITextDecoration = decorator.getDecoration("selection");
        var startLine:TextLine = indexToLine(selection.x);
        var endLine:TextLine = indexToLine(selection.y);
        
        decoration.draw(selections.addChildAt(new Sprite(), 0) as Sprite, decoration.setup(selection, startLine, endLine));
      }
      
      if(caretIndex >= 0)
      {
        var fontSize:Number = 12;
        var cursor:Cursor = new Cursor(fontSize);
        var position:Point = indexToPoint(caretIndex);
        selections.addChild(cursor);
        cursor.x = position.x;
        cursor.y = position.y;
      }
    }
    */
    
    /**
     * @private
     *
     * Returns an index for the given point, assuming the point
     * is relative to the container.
     */
    /*protected function pointToIndex(point:Point):int
    {
      var line:TextLine;
      var index:int = 0;
      var i:int = 0;
      var n:int = container.numChildren;
      
      for(i = 0; i < n; i++)
      {
        line = TextLine(container.getChildAt(i));
        index = line.getAtomIndexAtPoint(point.x, point.y);
        if(index > -1)
          return line.textBlockBeginIndex + index;
      }
      
      return 0;
    }*/
    
    /**
     * @private
     *
     * Returns a point relative to the container for the given
     * index.
     */
    /*protected function indexToPoint(index:int):Point
    {
      var bounds:Rectangle;
      var line:TextLine = indexToLine(index);
      
      if(!line)
        return new Point();
      
      bounds = line.getAtomBounds(line.getAtomIndexAtCharIndex(index));
      return new Point(bounds.x + line.x, bounds.y + line.y);
    }*/
    
    /**
     * @private
     *
     * Returns a TextLine for the given index.
     */
    /*protected function indexToLine(index:int):TextLine
    {
      var line:TextLine;
      var i:int = 0;
      var n:int = container.numChildren;
      
      for(i = 0; i < n; i++)
      {
        line = TextLine(container.getChildAt(i));
        if(index >= line.textBlockBeginIndex && index < (line.textBlockBeginIndex + line.rawTextLength))
          return line;
      }
      
      return null;
    }*/
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