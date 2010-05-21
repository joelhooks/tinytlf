package mx.tinytlf
{
  import flash.display.Stage;
  
  import mx.tinytlf.decor.FlexTextDecor;
  import mx.tinytlf.styles.FlexTextStyler;
  
  import org.tinytlf.TextEngine;
  import org.tinytlf.decor.ITextDecor;
  import org.tinytlf.styles.ITextStyler;
  
  public class FlexTextEngine extends TextEngine
  {
    public function FlexTextEngine(stage:Stage)
    {
      super(stage);
    }
    
    override public function get decor():ITextDecor
    {
      if(!_decor)
        _decor = new FlexTextDecor();
      
      _decor.engine = this;
      
      return _decor;
    }
    
    override public function get styler():ITextStyler
    {
      if(!_styler)
        _styler = new FlexTextStyler();
      
      _styler.engine = this;
      
      return _styler;
    }
  }
}