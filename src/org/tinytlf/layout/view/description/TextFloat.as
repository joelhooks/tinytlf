package org.tinytlf.layout.view.description
{
  public class TextFloat extends Enum
  {
    public function TextFloat(identifier:String)
    {
      super(identifier);
    }
    
    public static const LEFT:TextFloat = new TextFloat("left");
    public static const RIGHT:TextFloat = new TextFloat("right");
  }
}