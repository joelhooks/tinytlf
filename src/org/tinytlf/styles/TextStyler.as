package org.tinytlf.styles
{
  import flash.text.engine.BreakOpportunity;
  import flash.text.engine.CFFHinting;
  import flash.text.engine.DigitCase;
  import flash.text.engine.DigitWidth;
  import flash.text.engine.ElementFormat;
  import flash.text.engine.FontDescription;
  import flash.text.engine.FontLookup;
  import flash.text.engine.FontPosture;
  import flash.text.engine.FontWeight;
  import flash.text.engine.Kerning;
  import flash.text.engine.LigatureLevel;
  import flash.text.engine.RenderingMode;
  import flash.text.engine.TextBaseline;
  import flash.text.engine.TextRotation;
  import flash.text.engine.TypographicCase;
  import flash.utils.Dictionary;
  
  import org.tinytlf.ITextEngine;
  import org.tinytlf.core.StyleAwareActor;
  
  public class TextStyler extends StyleAwareActor implements ITextStyler
  {
    protected var _engine:ITextEngine;
    public function get engine():ITextEngine
    {
      return _engine;
    }
    
    public function set engine(textEngine:ITextEngine):void
    {
      if(textEngine == _engine)
        return;
      
      _engine = textEngine;
    }
    
    public function getElementFormat(element:*):ElementFormat
    {
      var reduceBoilerplate:Function = function(style:String, defaultValue:*):*
        {
          return(getStyle(style) || defaultValue);
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
    
    protected var styleMap:Dictionary = new Dictionary(true);
    
    public function getMappedStyle(element:*):*
    {
      if(element in styleMap)
        return styleMap[element];
      
      return null;
    }
    
    public function mapStyle(element:*, value:*):void
    {
      styleMap[element] = value;
    }
    
    public function unMapStyle(element:*):Boolean
    {
      if(element in styleMap)
        return delete styleMap[element];
      
      return false;
    }
    
    //Statically generate a map of the properties in this object
    generatePropertiesMap(new TextStyler());
  }
}