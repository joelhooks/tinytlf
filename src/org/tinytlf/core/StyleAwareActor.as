package org.tinytlf.core
{
  import flash.utils.Proxy;
  import flash.utils.describeType;
  import flash.utils.flash_proxy;
  
  use namespace flash_proxy;
  
  /**
  * StyleAwareActor is a useful base class for objects with sealed properties
  * but who also wish to dynamically accept and store named values. 
  * 
  * Since he is a Proxy implementation, he overrides the flash_proxy functions 
  * for setting and retrieving data. If you are calling a sealed property on 
  * StyleAwareActor or one of his subclasses, the property or function is called
  * like normal. However, if you dynamically call or set a property on him, he
  * calls his <code>getStyle</code> and <code>setStyle</code> methods instead.
  * 
  * StyleAwareActor has an internal <code>styles</code> object on which these
  * properties and values are stored. However, you can override this
  * functionality by passing in your own implementation to store styles on. You
  * can do this by calling <code>setStyle("styleProxy", myProxyImplem)</code>.
  * This will set the <code>myProxyImpl</code> instance as the new internal 
  * styles storage object, as well as copy over all the key/value pairs currently 
  * on the <code>myProxyImpl</code> instance.
  * 
  * This is particularly useful if you wish to proxy together multiple 
  * StyleAwareActors for something similar to CSS inheritance, or to support
  * external CSS implementations (currently Flex and F*CSS).
  */
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
      // Because of negative logic, this statement seems backwards, but it's 
      // just coded for the most common case.
      if(styleProp != 'styleProxy')
        styles[styleProp] = newValue;
      else if(newValue)
      {
        var oldStyles:Object = styles;
        // Use newValue as the new styles object. This allows you to pass in
        // and use your own subclass of StyleAwareActor (useful for F*CSS or 
        // Flex styles)
        styles = newValue;
        // Copy values from the old styles to the new as long as they aren't 
        // already present the new styles
        for(var s:String in oldStyles)
          if(!(s in styles))
            this[s] = oldStyles[s];
      }
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