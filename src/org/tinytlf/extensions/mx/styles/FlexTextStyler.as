package org.tinytlf.extensions.mx.styles
{
  import flash.text.engine.*;
  
  import mx.core.Singleton;
  import mx.styles.CSSStyleDeclaration;
  import mx.styles.IStyleManager2;
  
  import org.tinytlf.extensions.mx.core.FlexStyleProxy;
  import org.tinytlf.styles.TextStyler;
  
  public class FlexTextStyler extends TextStyler
  {
    public function FlexTextStyler()
    {
      super();
      style = new FlexStyleProxy();
    }
    
    private var css:CSSStyleDeclaration;
    
    override public function set style(value:Object):void
    {
      super.style = value;
      
      if(value is String)
      {
        var name:String = String(value);
        if(name.indexOf(".") != 0)
          name = "." + name;
        
        css = new CSSStyleDeclaration(name);
        
        for(var s:String in styles)
          css.setStyle(s, styles[s]);
      }
    }
    
    override public function getElementFormat(element:*):ElementFormat
    {
      var mainStyleDeclaration:CSSStyleDeclaration = css || new CSSStyleDeclaration();
      var elementStyleDeclaration:CSSStyleDeclaration = styleManager.getStyleDeclaration(styleMap[element] || "") || new CSSStyleDeclaration();
      
      var reduceBoilerplate:Function = function(style:String, defaultValue:*):*
        {
          return (elementStyleDeclaration.getStyle(style) || mainStyleDeclaration.getStyle(style) || defaultValue);
        }
      
      return new ElementFormat(
        new FontDescription(
        reduceBoilerplate("fontFamily", "_sans"),
        reduceBoilerplate("fontWeight", FontWeight.NORMAL),
        reduceBoilerplate("fontStyle", FontPosture.NORMAL),
        reduceBoilerplate("fontLookup", FontLookup.DEVICE),
        reduceBoilerplate("renderingMode", RenderingMode.CFF),
        reduceBoilerplate("cffHinting", CFFHinting.HORIZONTAL_STEM)
        ),
        reduceBoilerplate("fontSize", 12),
        reduceBoilerplate("color", 0x0),
        reduceBoilerplate("fontAlpha", 1),
        reduceBoilerplate("textRotation", TextRotation.AUTO),
        reduceBoilerplate("dominantBaseLine", TextBaseline.ROMAN),
        reduceBoilerplate("alignmentBaseLine", TextBaseline.USE_DOMINANT_BASELINE),
        reduceBoilerplate("baseLineShift", 0.0),
        reduceBoilerplate("kerning", Kerning.ON),
        reduceBoilerplate("trackingRight", 0.0),
        reduceBoilerplate("trackingLeft", 0.0),
        reduceBoilerplate("locale", "en"),
        reduceBoilerplate("breakOpportunity", BreakOpportunity.AUTO),
        reduceBoilerplate("digitCase", DigitCase.DEFAULT),
        reduceBoilerplate("digitWidth", DigitWidth.DEFAULT),
        reduceBoilerplate("ligatureLevel", LigatureLevel.COMMON),
        reduceBoilerplate("typographicCase", TypographicCase.DEFAULT)
        );
    }
    
    protected function get styleManager():IStyleManager2
    {
      return Singleton.getInstance("mx.styles::IStyleManager2") as IStyleManager2;
    }
  }
}