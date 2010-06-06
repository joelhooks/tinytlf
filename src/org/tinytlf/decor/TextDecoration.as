package org.tinytlf.decor
{
  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.geom.Rectangle;
  import flash.text.engine.ContentElement;
  import flash.text.engine.GroupElement;
  import flash.text.engine.TextBlock;
  import flash.text.engine.TextLine;
  import flash.text.engine.TextLineMirrorRegion;
  import flash.text.engine.TextLineValidity;
  import flash.utils.Dictionary;
  import flash.utils.flash_proxy;
  import flash.utils.getDefinitionByName;
  
  import org.tinytlf.ITextEngine;
  import org.tinytlf.core.StyleAwareActor;
  import org.tinytlf.interaction.LineEventInfo;
  import org.tinytlf.layout.ITextContainer;
  
  use namespace flash_proxy;
  
  public class TextDecoration extends StyleAwareActor implements ITextDecoration
  {
    public function TextDecoration(styleName:String = "")
    {
      super(styleName);
    }
    
    private var _containers:Vector.<ITextContainer>;
    public function get containers():Vector.<ITextContainer>
    {
      return _containers;
    }
    
    public function set containers(textContainers:Vector.<ITextContainer>):void
    {
      if(textContainers === _containers)
        return;
      
      _containers = textContainers;
    }
    
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
    
    public function set styleProxy(proxy:Object):void
    {
      styles = proxy;
    }
    
    private var derivedParent:DisplayObjectContainer;
    
    public function setup(... args):Vector.<Rectangle>
    {
      var bounds:Vector.<Rectangle> = new Vector.<Rectangle>();
      
      if(args.length <= 0)
        return bounds;
      
      var arg:* = args[0];
      
      var uiLineClass:Class = LineEventInfo.uiLineClass;
      
      if(arg is ContentElement)
      {
        var element:ContentElement = arg as ContentElement;
        var regions:Vector.<TextLineMirrorRegion> = getMirrorRegions(element);
        if(regions.length <= 0)
          return bounds;
        
        var region:TextLineMirrorRegion;
        var rect:Rectangle;
        var line:DisplayObjectContainer;
        
        
        while(regions.length > 0)
        {
          region = regions.pop();
          rect = region.bounds;
          
          line = (uiLineClass && region.textLine.parent is uiLineClass) ? region.textLine.parent : region.textLine;
          
          bounds.push(new Rectangle(rect.x + line.x, rect.y + line.y, rect.width, rect.height));
        }
        
        // @TODO
        // When you specify decorations for a ContentElement, there's no way to
        // associate it with ITextContainers yet. This is a hack that grabs the
        // containers that hold the TextLines that this element is rendered with.
        // It might be better if this exists somewhere else, like if ITextLayout
        // could update Decor for any decorations that are keyed off ContentElements.
        if(containers.length == 0)
        {
          var lines:Vector.<TextLine> = getTextLines(element);
          var container:ITextContainer;
          while(lines.length)
          {
            container = engine.layout.getContainerForLine(lines.shift());
            if(containers.indexOf(container) ==  -1)
              containers.push(container);
          }
        }
      }
      else if(arg is TextLine)
      {
        var tl:TextLine = arg as TextLine;
        bounds.push(tl.getBounds(tl.parent));
      }
      else if(arg is uiLineClass)
      {
        var ui:DisplayObject = arg as DisplayObject;
        bounds.push(ui.getBounds(ui.parent));
      }
      else if(arg is Rectangle)
        bounds.push(arg);
      else if(arg is Vector.<Rectangle>)
        bounds = bounds.concat(arg);
      
      return bounds;
    }
    
    protected var spriteMap:Dictionary = new Dictionary(true);
    
    public function draw(bounds:Vector.<Rectangle>, layer:int = 0):void
    {
      if(!containers)
        return;
      
      spriteMap = new Dictionary(true);
      
      // 1. Iterate over containers
      // 2. Iterate over bounds
      // 3. Check intersection
      // 4. possibly create sprite -- add it to container.shapes
      // 5. associate bounds with proper sprite
      
      var i:int = 0;
      var n:int = containers.length;
      var j:int = 0;
      var k:int = bounds.length;
      
      var container:ITextContainer;
      var doc:DisplayObjectContainer;
      
      for(i = 0; i < n; i++)
      {
        container = containers[i];
        doc = container.target;
        
        for(j = 0; j < k; j++)
        {
          if(bounds[j].intersects(doc.getBounds(doc)))
          {
            if(! (container in spriteMap))
              spriteMap[container] = resolveLayer(container.shapes, layer);
            
            spriteMap[bounds[j]] = spriteMap[container];
          }
        }
      }
    }
    
    private function resolveLayer(shapes:Sprite, layer:int):Sprite
    {
      if(shapes.numChildren > layer)
        return Sprite(shapes.getChildAt(layer));
      
      var sprite:Sprite;
      var i:int = shapes.numChildren - 1;
      while(++i <= layer)
        sprite = Sprite(shapes.addChildAt(new Sprite(), i));
      
      return sprite;
    }
    
    protected function getTextBlock(element:ContentElement):TextBlock
    {
      if(!element)
        return null;
      
      return element.textBlock;
    }
    
    protected function getTextLines(element:ContentElement):Vector.<TextLine>
    {
      var lines:Vector.<TextLine> = new Vector.<TextLine>();
      var block:TextBlock = getTextBlock(element);
      if(!block)
        return lines;
      
      var firstLine:TextLine = block.getTextLineAtCharIndex(element.textBlockBeginIndex);
      lines.push(firstLine);
      
      var lastLine:TextLine = block.getTextLineAtCharIndex(element.textBlockBeginIndex + element.rawText.length - 1);
      
      var line:TextLine = firstLine;
      while(line != lastLine)
      {
        line = line.nextLine;
        if(line == null)
          break;
        lines.push(line);
      }
      
      return lines;
    }
    
    protected function getMirrorRegions(element:ContentElement):Vector.<TextLineMirrorRegion>
    {
      var regions:Vector.<TextLineMirrorRegion> = new Vector.<TextLineMirrorRegion>();
      var lines:Vector.<TextLine> = getTextLines(element);
      var region:TextLineMirrorRegion;
      
      var lineRegions:Vector.<TextLineMirrorRegion>;
      
      if(element is GroupElement)
      {
        var elem:ContentElement;
        var n:int = GroupElement(element).elementCount;
        for(var i:int = 0; i < n; i++)
        {
          elem = GroupElement(element).getElementAt(i);
          regions = regions.concat(getMirrorRegions(elem));
        }
      }
      
      var line:TextLine;
      
      while(lines.length > 0)
      {
        line = lines.pop();
        if(line.validity != TextLineValidity.VALID)
          continue;
        
        lineRegions = line.mirrorRegions.concat();
        while(lineRegions.length > 0)
        {
          region = lineRegions.pop();
          if(region.element == element)
            regions.push(region);
        }
      }
      
      return regions;
    }
    
    protected function getBounds(element:ContentElement):Vector.<Rectangle>
    {
      var bounds:Vector.<Rectangle> = new Vector.<Rectangle>();
      var regions:Vector.<TextLineMirrorRegion>;
      
      if(element is GroupElement)
      {
        var elem:ContentElement;
        var n:int = GroupElement(element).elementCount;
        for(var i:int = 0; i < n; i++)
        {
          elem = GroupElement(element).getElementAt(i);
          regions = getMirrorRegions(elem);
          while(regions.length > 0)
            bounds.push(regions.pop().bounds);
        }
      }
      else
      {
        regions = getMirrorRegions(element);
        while(regions.length > 0)
          bounds.push(regions.pop().bounds);
      }
      
      return bounds;
    }
    
    private var dispatcher:EventDispatcher = new EventDispatcher();
    
    public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void
    {
      dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
    }
    
    public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
    {
      dispatcher.removeEventListener(type, listener, useCapture);
    }
    
    public function dispatchEvent(event:Event):Boolean
    {
      return dispatcher.dispatchEvent(event);
    }
    
    public function hasEventListener(type:String):Boolean
    {
      return dispatcher.hasEventListener(type);
    }
    
    public function willTrigger(type:String):Boolean
    {
      return dispatcher.willTrigger(type);
    }
    
    //Statically generate a map of the properties in this object
    generatePropertiesMap(new TextDecoration());
  }
}