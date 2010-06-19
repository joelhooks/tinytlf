package org.tinytlf.extensions.fcss.xhtml.styles
{
  import com.flashartofwar.fcss.styles.IStyle;
  import com.flashartofwar.fcss.stylesheets.FStyleSheet;
  import com.flashartofwar.fcss.stylesheets.IStyleSheet;
  
  import flash.text.engine.ElementFormat;
  
  import org.tinytlf.extensions.fcss.xhtml.core.FStyleProxy;
  import org.tinytlf.styles.TextStyler;
  
  public class FCSSTextStyler extends TextStyler
  {
    override public function set style(value:Object):void
    {
      var sheet:FStyleSheet = new FStyleSheet();
      sheet.parseCSS(value as String);
      super.style = new FStyleProxy(sheet);
    }
    
    override public function getElementFormat(element:*):ElementFormat
    {
      if(!(element is Array))
        return super.getElementFormat(element);
      
      //  Context is an array of XML nodes, the currently processing
      //  node and its parents, along with all their attributes.
      var context:Array = (element as Array);
      var format:ElementFormat = new ElementFormat();
      
      var i:int = 0;
      var n:int = context.length;
      
      return format;
    }
  }
}
