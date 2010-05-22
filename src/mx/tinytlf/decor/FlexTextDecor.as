package mx.tinytlf.decor
{
  import org.tinytlf.decor.ITextDecoration;
  import org.tinytlf.decor.TextDecor;
  import org.tinytlf.layout.ITextContainer;
  
  public class FlexTextDecor extends TextDecor
  {
    public function FlexTextDecor()
    {
      super();
    }
    
    override public function getDecoration(styleProp:String, container:ITextContainer = null):ITextDecoration
    {
      var dec:ITextDecoration = super.getDecoration(styleProp, container);
      
      //Hoook this decoration into the Flex StyleManager
      if(dec)
        dec.styleProxy = new FlexStyleProxy(dec.styleName);
      
      return dec;
    }
  }
}