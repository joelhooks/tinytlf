package org.tinytlf.layout.description
{
  public class TextDirection extends Enum
  {
    public function TextDirection(identifier:String)
    {
      super(identifier);
    }
    
    public static const LTR:TextDirection = new TextDirection("ltr");
    public static const RTL:TextDirection = new TextDirection("rtl");
  }
}