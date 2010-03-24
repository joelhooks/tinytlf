package org.tiny.tlf.decoration
{
  import flash.text.engine.ContentElement;
  import flash.utils.Dictionary;
  
  import org.tiny.tlf.block.IBlockFactory;
  import org.tiny.tlf.utils.Type;
  
  public class TextDecorator implements ITextDecorator
  {
    public function TextDecorator()
    {
      mapDecoration("selection", SelectionDecoration);
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
    
    public function flushDecorations():Boolean
    {
      for(var element:*in map)
      {
        for(var styleProp:String in map[element])
          delete map[element][styleProp];
        
        delete map[element];
      }
      
      return true;
    }
    
    private var map:Dictionary = new Dictionary(true);
    
    public function getDecorations():Dictionary
    {
      return map;
    }
    
    public function addStyle(element:ContentElement, styleName:String):void
    {
//      var css:CSSStyleDeclaration = StyleManager.getStyleDeclaration(styleName) || new CSSStyleDeclaration();
//      for(var styleProp:String in decorationsMap)
//      {
//        if(evaluates(css.getStyle(styleProp)))
//          addDecoration(element, styleProp, styleName);
//        else
//          removeDecoration(element, styleProp);
//      }
//      
//      blockFactory.container.invalidateDecorations();
    }
    
    public function hasStyle(element:ContentElement):Boolean
    {
      return Boolean(element in map);
    }
    
    public function removeStyle(element:ContentElement):void
    {
      if(!hasStyle(element))
        return;
      
      for(var decorationProp:String in map[element])
        removeDecoration(element, decorationProp);
      
      delete map[element];
      
      blockFactory.container.invalidateDecorations();
    }
    
    public function addDecoration(element:ContentElement, styleProp:String, styleName:String = ""):void
    {
      var elementDecorations:Object = {};
      if(map[element])
        elementDecorations = map[element];
      
      if(hasDecoration(styleProp))
      {
        var decoration:ITextDecoration = getDecoration(styleProp);
        decoration.styleName = styleName;
        elementDecorations[styleProp] = decoration;
      }
      
      map[element] = elementDecorations;
      blockFactory.container.invalidateDecorations();
    }
    
    public function hasDecoration(styleProp:String):Boolean
    {
      return Boolean(styleProp in decorationsMap);
    }
    
    public function removeDecoration(element:ContentElement, decorationProp:String):void
    {
      var elementDecorations:Object = {};
      if(map[element])
        elementDecorations = map[element];
      
      if(decorationProp in elementDecorations)
        delete elementDecorations[decorationProp];
      
      blockFactory.container.invalidateDecorations();
    }
    
    protected function evaluates(input:*):Boolean
    {
      if(input == null)
        return false;
      
      if(input is Boolean)
        return Boolean(input);
      
      if(input is String)
        return(input != "" && input != "none");
      
      return true;
    }
    
    private var decorationsMap:Object = {};
    public function mapDecoration(styleProp:String, decoration:Class):Boolean
    {
      if(!Type.isType(decoration, ITextDecoration))
        throw new Error("Error mapping decoration.");
      
      decorationsMap[styleProp] = decoration;
      return true;
    }
    
    public function getDecoration(styleProp:String):ITextDecoration
    {
      if(!hasDecoration(styleProp))
        return null;
      
      return new decorationsMap[styleProp]();
    }
    
    public function unMapDecoration(styleProp:String):Boolean
    {
      if(styleProp in decorationsMap)
        return delete decorationsMap[styleProp];
      
      return false;
    }
  }
}