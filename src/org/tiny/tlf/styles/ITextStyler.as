package org.tiny.tlf.styles
{
  import flash.text.engine.ElementFormat;
  
  import org.tiny.tlf.block.IBlockFactory;

  public interface ITextStyler
  {
    function get blockFactory():IBlockFactory;
    function set blockFactory(factory:IBlockFactory):void;
    
    function get styleName():String;
    /**
    * The Flex styleName associated with a block of text. Typically
    * this defines the standard styles applied to all the textblock
    * objects, not individual words or elements. To get granular
    * control over ElementFormats, use #mapStyleName.
    */
    function set styleName(value:String):void;
    /**
    * Returns an ElementFormat for a given elementName.
    */
    function getElementFormat(elementName:String = ""):ElementFormat;
    
    /**
    * Returns the mapped styleName for the given elementName.
    * If no styleName is mapped, returns an empty string.
    */
    function getStyleValue(elementName:String):*;
    
    /**
    * The individual styleNames for any elementName. Here you have
    * granular control to tweak the ElementFormat for a given 
    * elementName.
    */
    function mapStyleName(elementName:String, styleValue:*):Boolean;
    function unMapStyleName(elementName:String):Boolean;
    
    function getStyle(styleProp:String):*;
    function setStyle(styleProp:String, value:*):void;
  }
}