package org.tiny.tlf.styles
{
  import flash.text.engine.ElementFormat;
  
  import org.tiny.tlf.block.IBlockFactory;
  
  public class TextStyler implements ITextStyler
  {
    public function TextStyler()
    {
    }
    
    private var _blockFactory:IBlockFactory;
    public function get blockFactory():IBlockFactory
    {
      return _blockFactory;
    }
    
    public function set blockFactory(factory:IBlockFactory):void
    {
      if(factory == _blockFactory)
        return;
      
      _blockFactory = factory;
    }
    
    private var _styleName:String = "";
//    private var styleDeclaration:CSSStyleDeclaration;
    public function get styleName():String
    {
      return _styleName;
    }
    
    public function set styleName(value:String):void
    {
      if(value === _styleName)
        return;
      
      _styleName = value;
//      styleDeclaration = StyleManager.getStyleDeclaration(styleName || "") || new CSSStyleDeclaration()
    }
    
    public function getElementFormat(elementName:String = ""):ElementFormat
    {
      return new ElementFormat();
//      var mainStyleDeclaration:CSSStyleDeclaration; //styleDeclaration || StyleManager.getStyleDeclaration(styleName || "") || new CSSStyleDeclaration();
//      var elementStyleDeclaration:CSSStyleDeclaration; //StyleManager.getStyleDeclaration(styleNameMap[elementName] || "") || new CSSStyleDeclaration();
//      
//      var reduceBoilerplate:Function = function(style:String, defaultValue:*):*
//        {
//          return(elementStyleDeclaration.getStyle(style) || mainStyleDeclaration.getStyle(style) || defaultValue);
//        }
//      
//      return new ElementFormat(
//        new FontDescription(
//        reduceBoilerplate("fontFamily", "_sans"),
//        reduceBoilerplate("fontWeight", FontWeight.NORMAL),
//        reduceBoilerplate("fontStyle", FontPosture.NORMAL),
//        reduceBoilerplate("fontLookup", FontLookup.DEVICE),
//        reduceBoilerplate("renderingMode", RenderingMode.CFF),
//        reduceBoilerplate("cffHinting", CFFHinting.HORIZONTAL_STEM)
//        ),
//        reduceBoilerplate("fontSize", 12),
//        reduceBoilerplate("fontColor", 0x0),
//        reduceBoilerplate("fontAlpha", 1),
//        reduceBoilerplate("textRotation", TextRotation.AUTO),
//        reduceBoilerplate("dominantBaseLine", TextBaseline.ROMAN),
//        reduceBoilerplate("alignmentBaseLine", TextBaseline.USE_DOMINANT_BASELINE),
//        reduceBoilerplate("baseLineShift", 0.0),
//        reduceBoilerplate("kerning", Kerning.ON),
//        reduceBoilerplate("trackingRight", 0.0),
//        reduceBoilerplate("trackingLeft", 0.0),
//        reduceBoilerplate("locale", "en"),
//        reduceBoilerplate("breakOpportunity", BreakOpportunity.AUTO),
//        reduceBoilerplate("digitCase", DigitCase.DEFAULT),
//        reduceBoilerplate("digitWidth", DigitWidth.DEFAULT),
//        reduceBoilerplate("ligatureLevel", LigatureLevel.COMMON),
//        reduceBoilerplate("typographicCase", TypographicCase.DEFAULT)
//        );
    }
    
    private var styleNameMap:Object = {};
    
    public function getStyleValue(elementName:String):*
    {
      if(elementName in styleNameMap)
        return styleNameMap[elementName];
      
      return "";
    }
    
    public function mapStyleName(elementName:String, styleValue:*):Boolean
    {
      styleNameMap[elementName] = styleValue;
      return true;
    }
    
    public function unMapStyleName(elementName:String):Boolean
    {
      if(elementName in styleNameMap)
        return delete styleNameMap[elementName];
      
      return false;
    }
    
    public function getStyle(styleProp:String):*
    {
//      if(styleDeclaration)
//        return styleDeclaration.getStyle(styleProp);
      
      return null;
    }
    
    public function setStyle(styleProp:String, value:*):void
    {
//      if(styleDeclaration)
//        styleDeclaration.setStyle(styleProp, value);
    }
  }
}