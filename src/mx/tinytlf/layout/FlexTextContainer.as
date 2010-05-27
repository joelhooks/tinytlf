package mx.tinytlf.layout
{
  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import flash.text.engine.TextBlock;
  import flash.text.engine.TextLine;
  
  import mx.tinytlf.UITextLine;
  
  import org.tinytlf.layout.view.TextContainerBase;
  
  public class FlexTextContainer extends TextContainerBase
  {
    public function FlexTextContainer(container:DisplayObjectContainer, width:Number = NaN, height:Number = NaN)
    {
      super(container, width, height);
    }
    
    override protected function hookLine(line:TextLine):DisplayObjectContainer
    {
      return new UITextLine(line);
    }
    
    override public function hasLine(line:TextLine):Boolean
    {
      var child:DisplayObject;
      var n:int = container.numChildren;
      
      for(var i:int = 0; i < n; i++)
      {
        child = container.getChildAt(i);
        
        if(child is UITextLine && DisplayObjectContainer(child).contains(line))
          return true;
      }
      
      return false;
    }
  }
}