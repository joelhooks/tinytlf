package org.tiny.tlf.decoration
{
  import flash.display.Shape;
  import flash.geom.Rectangle;
  import flash.text.engine.ContentElement;
  import flash.text.engine.GroupElement;
  import flash.text.engine.TextBlock;
  import flash.text.engine.TextLine;
  import flash.text.engine.TextLineMirrorRegion;
  
  public class TextDecoration implements ITextDecoration
  {
    public function TextDecoration(styleName:String = "")
    {
      this.styleName = styleName;
    }
    
    private var _styleName:String = "";
    public function get styleName():String
    {
      return _styleName;
    }
    
    public function set styleName(value:String):void
    {
      if(value === _styleName)
        return;
      
      _styleName = value;
//      css = StyleManager.getStyleDeclaration(styleName) || new CSSStyleDeclaration();
    }
    
//    private var css:CSSStyleDeclaration;
    public function getStyle(styleProp:String):*
    {
//      if(css)
//        return css.getStyle(styleProp);
      
      return null;
    }
    
    public function setStyle(styleProp:String, newValue:*):void
    {
//      if(css)
//        css.setStyle(styleProp, newValue);
    }
    
    public function setup(...args):Vector.<Rectangle>
    {
      var bounds:Vector.<Rectangle> = new Vector.<Rectangle>();
      
      return bounds;
    }
    
    public function draw(shape:Shape, bounds:Vector.<Rectangle>):void
    {
      shape.graphics.clear();
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
  }
}