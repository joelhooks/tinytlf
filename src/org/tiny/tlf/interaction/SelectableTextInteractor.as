package org.tiny.tlf.interaction
{
  import flash.events.IEventDispatcher;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.text.engine.TextBlock;
  import flash.text.engine.TextLine;
  import flash.ui.Keyboard;
  import flash.ui.Mouse;
  import flash.ui.MouseCursor;
  import flash.utils.getTimer;
  
  import org.tiny.tlf.utils.BitFlagUtil;
  import org.tiny.tlf.utils.FTEUtil;
  import org.tiny.tlf.utils.KeyboardUtil;
  
  public class SelectableTextInteractor extends TextInteractorBase
  {
    private var _useKeyboard:Boolean = false;
    
    public function SelectableTextInteractor(useKeyboard:Boolean = false)
    {
      _useKeyboard = useKeyboard;
      super();
    }
    
//    override public function getMirror(elementName:String = ""):IEventDispatcher
//    {
//      var mirror:IEventDispatcher = super.getMirror(elementName);
//      
//      mirror.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
//      mirror.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
//      mirror.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
//      mirror.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
//      
//      mirror.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true);
//      mirror.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler, false, 0, true);
//      
//      return mirror;
//    }
    
    private var selection:Point;
    
    override protected function mouseMoveHandler(event:MouseEvent):void
    {
      super.mouseMoveHandler(event);
      
      if(BitFlagUtil.isSet(mouseState, stateUp))
      {
        Mouse.cursor = MouseCursor.IBEAM;
      }
      else
      {
        var info:LineInfo = LineInfo.getInfo(event);
        if(!info)
          return;
        
        var line:TextLine = info.line;
        var atomIndex:int = FTEUtil.getAtomIndexAtPoint(event.stageX, event.stageY, line);
        var caret:int = blockFactory.container.caretIndex;
        
        if(BitFlagUtil.isSet(mouseState, stateSingle))
        {
          if(caret == -1)
            blockFactory.container.caretIndex = atomIndex;
          blockFactory.container.select(new Point(event.stageX, event.stageY));
        }
        else
        {
          var newSelection:Point = new Point();
          newSelection.x = line.textBlock.findPreviousWordBoundary(atomIndex > 0 ? atomIndex : 1);
          newSelection.y = line.textBlock.findNextWordBoundary(atomIndex > 0 ? atomIndex : 1);
          
          var left:Boolean = newSelection.x <= selection.x;
          
          blockFactory.container.caretIndex = left ? newSelection.x : newSelection.y;
          blockFactory.container.select(left ? newSelection.x : selection.x, left ? selection.y - 1 : newSelection.y - 1);
        }
        blockFactory.container.invalidateSelection();
      }
    }
    
    override protected function mouseOutHandler(event:MouseEvent):void
    {
      super.mouseOutHandler(event);
      
      if(BitFlagUtil.isSet(mouseState, stateUp))
        Mouse.cursor = MouseCursor.ARROW;
    }
    
    override protected function mouseDownHandler(event:MouseEvent):void
    {
      super.mouseDownHandler(event);
      
      var info:LineInfo = LineInfo.getInfo(event);
      if(!info)
        return;
      
      var line:TextLine = info.line;
      line.stage.focus = line;
      var atomIndex:int = FTEUtil.getAtomIndexAtPoint(event.stageX, event.stageY, line);
      
      //single down
      if(BitFlagUtil.isSet(mouseState, stateSingle))
      {
        selection = null;
        blockFactory.container.caretIndex = atomIndex;
        blockFactory.container.select();
      }
      //Handle double click
      else
      {
        selection = new Point();
        selection.x = line.textBlock.findPreviousWordBoundary(atomIndex || 1);
        selection.y = line.textBlock.findNextWordBoundary(atomIndex);
        
        blockFactory.container.caretIndex = selection.x;
        blockFactory.container.select(selection.x, selection.y - 1);
      }
    }
    
    override protected function mouseUpHandler(event:MouseEvent):void
    {
      var fromSingle:Boolean = BitFlagUtil.isSet(mouseState, stateSingle);
      
      super.mouseUpHandler(event);
      
      if(!BitFlagUtil.isSet(mouseState, stateOver))
        Mouse.cursor = MouseCursor.ARROW;
      
      var info:LineInfo = LineInfo.getInfo(event);
      if(!info)
        return;
      
      info.line.stage.focus = info.line;
      
      if(fromSingle)
      {
        selection = null;
        blockFactory.container.caretIndex = FTEUtil.getAtomIndexAtPoint(event.stageX, event.stageY, info.line);
      }
      
      blockFactory.container.invalidateSelection();
    }
    
    protected var lastKeyPressTime:int = 0;
    
    override protected function keyDownHandler(event:KeyboardEvent):void
    {
      super.keyDownHandler(event);
      
      if(!_useKeyboard)
        return;
      
      var keyPressTime:int = getTimer();
      if(keyPressTime - lastKeyPressTime < 10)
        return;
      
      lastKeyPressTime = keyPressTime;
      
      if(!KeyboardUtil.isNavigable(event.keyCode))
        return;
      
      var info:LineInfo = LineInfo.getInfo(event);
      if(!info)
        return;
      
      var line:TextLine = info.line;
      var oldCaretIndex:int = blockFactory.container.caretIndex;
      var newCaretIndex:int = handleNavigation(event.keyCode, oldCaretIndex, line);
      
      blockFactory.container.caretIndex = newCaretIndex;
      if(event.shiftKey || event.ctrlKey || event.altKey)
      {
        if(selection == null)
          selection = new Point(oldCaretIndex, newCaretIndex);
        
        var _x:int = 0;
        var _y:int = 0;
        
        if(newCaretIndex == selection.x)
        {
          blockFactory.container.select();
        }
        else
        {
          var movingLeft:Boolean = newCaretIndex < oldCaretIndex;
          var leftOfCaret:Boolean = newCaretIndex < selection.x;
          
          if(event.ctrlKey || event.altKey)
          {
            _x = selection.x;
            var b:TextBlock = line.textBlock;
            
            _y = ((!movingLeft && !leftOfCaret) || (!movingLeft && leftOfCaret)) ? 
              b.findNextWordBoundary((newCaretIndex < line.textBlockBeginIndex + line.rawTextLength) ? newCaretIndex : newCaretIndex - 1) : 
              b.findPreviousWordBoundary(newCaretIndex > 0 ? newCaretIndex : 1);
            
            blockFactory.container.caretIndex = movingLeft ? _y : _y + 1;
          }
          else
          {
            _x = selection.x;
            _y = ((!movingLeft && !leftOfCaret) || (movingLeft && !leftOfCaret)) ? newCaretIndex - 1 : newCaretIndex;
          }
          
          if(event.shiftKey)
            blockFactory.container.select(_x, _y);
          else
            blockFactory.container.select();
        }
      }
      else
      {
        selection = null;
        blockFactory.container.select();
      }
    }
    
    protected function handleNavigation(keyCode:int, index:int, line:TextLine):int
    {
      if(!KeyboardUtil.isNavigable(keyCode))
        return index;
      
      var focusLine:TextLine = line;
      var returnIndex:int = 0;
      
      switch(keyCode)
      {
        case Keyboard.LEFT:
          index--;
          break;
        case Keyboard.RIGHT:
          index++;
          break;
        case Keyboard.UP:
          focusLine = line.previousLine || line;
          if(focusLine == line)
            index = 0;
          else
            index = focusLine.textBlockBeginIndex + index - line.textBlockBeginIndex;
          break;
        case Keyboard.DOWN:
          focusLine = line.nextLine || line;
          if(focusLine == line || focusLine.nextLine == null)
            index = focusLine.textBlockBeginIndex + focusLine.rawTextLength - 1;
          else
            index = focusLine.textBlockBeginIndex + index - line.textBlockBeginIndex;
          break;
      }
      
      if(KeyboardUtil.isChar(keyCode))
        index++;
      
      focusLine.stage.focus = focusLine;
      
      return index;
    }
  }
}