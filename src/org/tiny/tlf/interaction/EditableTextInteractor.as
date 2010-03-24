package org.tiny.tlf.interaction
{
  import flash.display.BlendMode;
  import flash.display.DisplayObject;
  import flash.events.KeyboardEvent;
  import flash.text.engine.ContentElement;
  import flash.text.engine.GraphicElement;
  import flash.text.engine.TextElement;
  import flash.text.engine.TextLine;
  import flash.ui.Keyboard;
  import flash.utils.getTimer;
  
  import org.tiny.tlf.utils.FTEUtil;
  import org.tiny.tlf.utils.KeyboardUtil;
  
  public class EditableTextInteractor extends SelectableTextInteractor
  {
    public function EditableTextInteractor()
    {
      super(true);
    }
    
    override protected function keyDownHandler(event:KeyboardEvent):void
    {
      var savedKeyPressTime:int = lastKeyPressTime;
      
      super.keyDownHandler(event);
      
      var keyPressTime:int = getTimer();
      if(keyPressTime - savedKeyPressTime < 10)
        return;
      
      if(!KeyboardUtil.isNavigable(event.keyCode))
        return;
      
      var info:LineInfo = LineInfo.getInfo(event);
      if(!info)
        return;
      
      var line:TextLine = info.line;
      var caretIndex:int = blockFactory.container.caretIndex;
      
      if(handleDelete(event.keyCode, caretIndex, line) || handleInsert(event, caretIndex, line))
        blockFactory.container.invalidate();
    }
    
    override protected function handleNavigation(keyCode:int, index:int, line:TextLine):int
    {
      index = super.handleNavigation(keyCode, index, line);
      
      if(!KeyboardUtil.isRemover(keyCode))
        return index;
      
      switch(keyCode)
      {
        case Keyboard.BACKSPACE:
//          var content:ContentElement = FTEUtil.getContentElementAt(line.textBlock.content, index);
//          if(content is GraphicElement)
//          {
//            var graphic:DisplayObject = GraphicElement(content).graphic;
//            if(graphic.blendMode == BlendMode.INVERT && keyCode == Keyboard.BACKSPACE)
//              index--;
//            else
//              graphic.blendMode = BlendMode.INVERT;
//          }
//          else if(keyCode == Keyboard.BACKSPACE)
            index--;
          break;
        case Keyboard.DELETE:
          break;
        default:
          index++;
          break;
      }
      
      return index;
    }
    
    protected function handleDelete(keyCode:int, index:int, line:TextLine):Boolean
    {
      if(!KeyboardUtil.isRemover(keyCode))
        return false;
      
      var element:ContentElement = FTEUtil.getContentElementAt(line.textBlock.content, index);
      index -= element.textBlockBeginIndex;
      
      var elementIndex:int;
      
//      if(element is GraphicElement)
//      {
//        var graphic:DisplayObject = GraphicElement(element).graphic;
//        if(graphic.blendMode == BlendMode.MULTIPLY)
//        {
//          elementIndex = element.groupElement.getElementIndex(element);
//          element.groupElement.replaceElements(elementIndex, elementIndex + 1, new Vector.<ContentElement>());
//        }
//      }
      if(element is TextElement)
      {
        var text:TextElement = TextElement(element);
        if(text.rawText.length > 0)
          text.replaceText(index, index + 1, "");
        
        if(text.rawText.length == 0)
        {
          elementIndex = text.groupElement.getElementIndex(text);
          text.groupElement.replaceElements(elementIndex, elementIndex + 1, new Vector.<ContentElement>());
        }
      }
      else
        return false;
      
      return true;
    }
    
    protected function handleInsert(event:KeyboardEvent, index:int, line:TextLine):Boolean
    {
      if(KeyboardUtil.isModifier(event.keyCode) || KeyboardUtil.isRemover(event.keyCode))
        return false;
      
      index = index > 0 ? index - 1 : 0;
      
      var element:ContentElement = FTEUtil.getContentElementAt(line.textBlock.content, index);
      index -= element.textBlockBeginIndex;
      
      if(element is TextElement)
      {
        var text:TextElement = TextElement(element);
        text.replaceText(index, index, String.fromCharCode(event.charCode));
      }
      else
        return false;
      
      return true;
    }
  }
}