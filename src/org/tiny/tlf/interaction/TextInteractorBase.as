package org.tiny.tlf.interaction
{
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  
  import org.tiny.tlf.block.IBlockFactory;
  import org.tiny.tlf.interaction.gestures.IGesture;
  
  public class TextInteractorBase extends TextDispatcherBase implements ITextInteractor
  {
    public function TextInteractorBase()
    {
      super(null);
    }
    
    private var _blockFactory:IBlockFactory;
    public function get blockFactory():IBlockFactory
    {
      return _blockFactory;
    }
    
    public function set blockFactory(factory:IBlockFactory):void
    {
      if(factory == _blockFactory)
        return;
      
      _blockFactory = factory;
    }
    
    public function get dispatcher():EventDispatcher
    {
      return this;
    }
    
    protected var gestures:Vector.<IGesture> = new Vector.<IGesture>();
    public function addGesture(gesture:IGesture):void
    {
      if(gestures.indexOf(gesture) < 0)
        gestures.push(gesture);
    }
    
    override protected function keyDownHandler(event:KeyboardEvent):void
    {
      super.keyDownHandler(event);
      eventHandler(event);
    }
    
    override protected function keyUpHandler(event:KeyboardEvent):void
    {
      super.keyUpHandler(event);
      eventHandler(event);
    }
    
    override protected function mouseDownHandler(event:MouseEvent):void
    {
      super.mouseDownHandler(event);
      eventHandler(event);
    }
    
    override protected function mouseMoveHandler(event:MouseEvent):void
    {
      super.mouseMoveHandler(event);
      eventHandler(event);
    }
    
    override protected function mouseOutHandler(event:MouseEvent):void
    {
      super.mouseOutHandler(event);
      eventHandler(event);
    }
    
    override protected function mouseUpHandler(event:MouseEvent):void
    {
      super.mouseUpHandler(event);
      eventHandler(event);
    }
    
    protected function eventHandler(event:Event):void
    {
      for each(var gesture:IGesture in gestures)
        gesture.execute(event);
    }
  }
}