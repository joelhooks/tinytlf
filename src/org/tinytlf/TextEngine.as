package org.tinytlf
{
  import flash.display.DisplayObjectContainer;
  import flash.display.Shape;
  import flash.display.Stage;
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.text.engine.TextBlock;
  import flash.utils.setTimeout;
  
  import org.tinytlf.decor.ITextDecor;
  import org.tinytlf.decor.TextDecor;
  import org.tinytlf.interaction.ITextInteractor;
  import org.tinytlf.interaction.TextInteractorBase;
  import org.tinytlf.layout.view.ITextContainer;
  import org.tinytlf.layout.ITextLayout;
  import org.tinytlf.layout.TextLayoutBase;
  import org.tinytlf.layout.model.factory.AbstractLayoutModelFactory;
  import org.tinytlf.layout.model.factory.ILayoutModelFactory;
  import org.tinytlf.styles.ITextStyler;
  import org.tinytlf.styles.TextStyler;
  
  public class TextEngine extends EventDispatcher implements ITextEngine
  {
    protected var stage:Stage;
    public function TextEngine(stage:Stage)
    {
      this.stage = stage;
    }
    
    protected var _blockFactory:ILayoutModelFactory;
    
    public function get blockFactory():ILayoutModelFactory
    {
      if(!_blockFactory)
        _blockFactory = new AbstractLayoutModelFactory();
      
      return _blockFactory;
    }
    
    public function set blockFactory(value:ILayoutModelFactory):void
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
      layout.render(blockFactory.blocks);
    }
    
    public function renderDecorations():void
    {
      var containers:Vector.<ITextContainer> = layout.containers;
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