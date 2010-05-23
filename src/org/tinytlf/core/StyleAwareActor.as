package org.tinytlf.core
{
  import flash.utils.Proxy;
  import flash.utils.describeType;
  import flash.utils.flash_proxy;
  
  use namespace flash_proxy;
  
  public class StyleAwareActor extends Proxy implements IStyleAware
  {
    public function StyleAwareActor(styleObject:Object = null)
    {
      if(!styleObject)
        return;
      
      if(styleObject is String)
        styleName = String(styleObject);
      else
        for(var prop:String in styleObject)
          this[prop] = styleObject[prop];
    }
    
    public function toString():String
    {
      return styleName;
    }
    
    private var _styleName:String = "";
    public function get styleName():String
    {
      return _styleName;
    }
    
    public function set styleName(name:String):void
    {
      if(name === _styleName)
        return;
      
      if(name.indexOf(".") != 0)
        name = "." + name;
      
      _styleName = name;
      styles['styleName'] = name;
    }
    
    protected var styles:Object = {};
    
    public function getStyle(styleProp:String):*
    {
      return styles[styleProp];
    }
    
    public function setStyle(styleProp:String, newValue:*):void
    {
      if(styleProp != 'styleProxy')
        styles[styleProp] = newValue;
      else if(newValue)
        for(var s:String in newValue)
          this[s] = newValue[s];
    }
    
    override flash_proxy function callProperty(name:*, ...parameters):*
    {
      if(name in this && this[name] is Function)
        return (this[name] as Function).apply(null, parameters);
      
      if(name == 'toString')
        return styleName;
    }
    
    override flash_proxy function setProperty(name:*, value:*):void
    {
      if(name in propertiesMap)
        this[name] = value;
      else
        setStyle(name, value);
    }
    
    override flash_proxy function getProperty(name:*):*
    {
      if(name in this)
        return this[name];
      
      return getStyle(name);
    }
    
    override flash_proxy function hasProperty(name:*):Boolean
    {
      return propertiesMap ? name in propertiesMap : false;
    }
    
    protected var names:Array = [];
    
    override flash_proxy function nextNameIndex(index:int):int
    {
      if(index == 0)
      {
        names.length = 0;
        var prop:String;
        for(prop in propertiesMap)
          names.push(prop);
        for(prop in styles)
          names.push(prop);
      }
      
      return names[index];
    }
    
    override flash_proxy function nextName(index:int):String
    {
      return names[index - 1];
    }
    
    override flash_proxy function nextValue(index:int):*
    {
      return this[names[index]];
    }
    
    generatePropertiesMap(new StyleAwareActor());
    
    private static var propertiesMap:Object;
    
    protected static function generatePropertiesMap(typeOf:*):void
    {
      propertiesMap = {};
      
      var type:XML = describeType(typeOf);
      var prop:XML;
      for each(prop in type..method)
      {
        propertiesMap[prop.@name] = true;
      }
      
      for each(prop in type..accessor.(@access == "readwrite"))
      {
        propertiesMap[prop.@name] = true;
      }
    }
  }
}