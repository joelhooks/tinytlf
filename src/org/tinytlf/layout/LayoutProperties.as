package org.tinytlf.layout
{
  import org.tinytlf.layout.view.description.TextAlign;
  import org.tinytlf.layout.view.description.TextDirection;
  import org.tinytlf.layout.view.description.TextFloat;
  import org.tinytlf.layout.view.description.TextTransform;

  public class LayoutProperties
  {
    public function LayoutProperties(props:Object = null)
    {
      if(!props)
        return;
      
      for(var prop:String in props)
      {
        if(prop in this)
          this[prop] = props[prop]
      }
    }
    
    public var associatedItem:*;
    
    public var width:Number = 0;
    public var lineHeight:Number = 0;
    public var textIndent:Number = 0;
    public var letterSpacing:Number = 0;
    public var wordSpacing:Number = 0;
    public var paddingLeft:Number = 0;
    public var paddingRight:Number = 0;
    
    public var textAlign:TextAlign = TextAlign.LEFT;
    public var textDirection:TextDirection = TextDirection.LTR;
    public var textTransform:TextTransform = TextTransform.NONE;
    public var float:TextFloat = TextFloat.LEFT;
  }
}