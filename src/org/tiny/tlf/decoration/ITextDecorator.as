package org.tiny.tlf.decoration
{
  import flash.text.engine.ContentElement;
  import flash.utils.Dictionary;
  
  import org.tiny.tlf.block.IBlockFactory;

  public interface ITextDecorator
  {
    function get blockFactory():IBlockFactory;
    function set blockFactory(factory:IBlockFactory):void;
    
    function addStyle(element:ContentElement, styleName:String):void;
    function hasStyle(element:ContentElement):Boolean;
    function removeStyle(element:ContentElement):void;
    
    function addDecoration(element:ContentElement, decorationProp:String, styleName:String = ""):void;
    function hasDecoration(styleProp:String):Boolean;
    function removeDecoration(element:ContentElement, decorationProp:String):void
      
    function getDecorations():Dictionary;
    function flushDecorations():Boolean;
    
    function mapDecoration(styleProp:String, decoration:Class):Boolean;
    function getDecoration(styleProp:String):ITextDecoration;
    function unMapDecoration(styleProp:String):Boolean;
  }
}