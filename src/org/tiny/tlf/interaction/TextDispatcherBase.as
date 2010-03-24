package org.tiny.tlf.interaction
{
  import flash.events.EventDispatcher;
  import flash.events.IEventDispatcher;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.utils.getTimer;
  
  import org.tiny.tlf.utils.BitFlagUtil;
  
  public class TextDispatcherBase extends EventDispatcher
  {
    public function TextDispatcherBase(target:IEventDispatcher=null)
    {
      super(target);
      
      addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
      addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
      addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
      addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
      
      addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
      addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
    }
    
    protected static const stateUp:uint = 0x0001;
    protected static const stateOver:uint = 0x0002;
    protected static const stateSingle:uint = 0x0004;
    
    protected static var mouseState:uint = stateUp | stateSingle;
    
    protected function mouseMoveHandler(event:MouseEvent):void
    {
      mouseState |= stateOver;
    }
    
    protected function mouseOutHandler(event:MouseEvent):void
    {
      mouseState &= ~stateOver;
    }
    
    private static var doubleClickTime:int = 0;
    protected function mouseDownHandler(event:MouseEvent):void
    {
      var time:int = getTimer();
      if(time - doubleClickTime < 500)
        mouseState &= ~stateSingle;
      else
        mouseState |= stateSingle;
      
      doubleClickTime = time;
      
      mouseState &= stateUp;
    }
    
    protected function mouseUpHandler(event:MouseEvent):void
    {
      mouseState |= (stateSingle | stateUp);
    }
    
    protected function keyDownHandler(event:KeyboardEvent):void
    {
    }
    
    protected function keyUpHandler(event:KeyboardEvent):void
    {
    }
  }
}