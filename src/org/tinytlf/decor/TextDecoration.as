package org.tinytlf.decor
{
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.geom.Rectangle;
  import flash.text.engine.ContentElement;
  import flash.text.engine.GroupElement;
  import flash.text.engine.TextBlock;
  import flash.text.engine.TextLine;
  import flash.text.engine.TextLineMirrorRegion;
  import flash.utils.Proxy;
  import flash.utils.describeType;
  import flash.utils.flash_proxy;
  
  import mx.tinytlf.UITextLine;
  
  import org.tinytlf.core.StyleAwareActor;
  import org.tinytlf.layout.ITextContainer;
  
  use namespace flash_proxy;
  
  public class TextDecoration extends StyleAwareActor implements ITextDecoration
  {
    public function TextDecoration(styleName:String = "")
    {
      super(styleName);
    }
    
    private var _container:ITextContainer;
    public function get container():ITextContainer
    {
      return _container;
    }
    
    public function set container(textContainer:ITextContainer):void
    {
      if(textContainer === _container)
        return;
      
      _container = textContainer;
    }
    
    public function set styleProxy(proxy:Object):void
    {
      styles = proxy;
    }
    
    public function setup(... args):Vector.<Rectangle>
    {
      var bounds:Vector.<Rectangle> = new Vector.<Rectangle>();
      
      if(args.length <= 0)
        return bounds;
      
      var arg:* = args[0];
      
      if(arg is ContentElement)
      {
        var element:ContentElement = arg as ContentElement;
        var regions:Vector.<TextLineMirrorRegion> = getMirrorRegions(element);
        if(regions.length <= 0)
          return bounds;
        
        var region:TextLineMirrorRegion;
        
        while(regions.length > 0)
        {
          region = regions.pop();
          bounds.push(new Rectangle(region.bounds.x + region.textLine.x, region.bounds.y + region.textLine.y, region.bounds.width, region.bounds.height));
        }
      }
      else if(arg is TextLine)
      {
        var tl:TextLine = arg as TextLine;
        bounds.push(tl.getBounds(tl.parent));
      }
      else if(arg is UITextLine)
      {
        var ui:UITextLine = arg as UITextLine;
        bounds.push(ui.getBounds(ui.parent));
      }
      else if(arg is Rectangle)
        bounds.push(arg);
      else if(arg is Vector.<Rectangle>)
        bounds = bounds.concat(arg);
      
      return bounds;
    }
    
    public function draw(parent:Sprite, bounds:Vector.<Rectangle>):void
    {
      container.shapes.addChild(parent);
      parent.graphics.clear();
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
      
      while(lines.length > 0)
      {
        lineRegions = lines.pop().mirrorRegions.concat();
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