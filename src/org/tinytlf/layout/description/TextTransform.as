package org.tinytlf.layout.description
{
  public class TextTransform extends Enum
  {
    public function TextTransform(identifier:String)
    {
      super(identifier);
    }
    
    public static const CAPITALIZE:TextTransform = new TextTransform('capitalize');
    public static const UPPERCASE:TextTransform = new TextTransform('uppercase');
    public static const LOWERCASE:TextTransform = new TextTransform('lowercase');
    public static const NONE:TextTransform = new TextTransform('none');
  }
}