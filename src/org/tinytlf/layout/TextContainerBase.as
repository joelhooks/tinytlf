package org.tinytlf.layout
{
  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import flash.display.Sprite;
  import flash.text.engine.LineJustification;
  import flash.text.engine.SpaceJustifier;
  import flash.text.engine.TextBlock;
  import flash.text.engine.TextLine;
  
  import org.tinytlf.ITextEngine;
  import org.tinytlf.layout.description.TextAlign;
  
  public class TextContainerBase implements ITextContainer
  {
    protected var _width:Number = NaN;
    protected var _height:Number = NaN;
    
    public function TextContainerBase(container:DisplayObjectContainer, width:Number = NaN, height:Number = NaN)
    {
      this.container = container;
    }
    
    private var _container:DisplayObjectContainer;
    public function get container():DisplayObjectContainer
    {
      return _container;
    }
    
    public function set container(doc:DisplayObjectContainer):void
    {
      if(doc == _container)
        return;
      
      _container = doc;
      
      if(container.width == 0)
        container.width = 100;
      if(container.height == 0)
        container.height = 100;
      
      shapes = new Sprite();
      
      container.addChild(shapes);
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
    
    private var _shapes:DisplayObjectContainer;
    public function get shapes():DisplayObjectContainer
    {
      return _shapes;
    }
    
    public function set shapes(shapesContainer:DisplayObjectContainer):void
    {
      if(shapesContainer === _shapes)
        return;
      
      var children:Array = [];
      
      if(shapes)
      {
        while(shapes.numChildren)
          children.push(shapes.removeChildAt(0));
        
        if(shapes.parent && shapes.parent.contains(shapes))
          shapes.parent.removeChild(shapes);
      }
      
      _shapes = shapesContainer;
      
      while(children.length)
        shapes.addChild(children.shift());
    }
    
    public function get width():Number
    {
      return _width || container.width;
    }
    
    public function set width(value:Number):void
    {
      _width = value;
    }
    
    public function get height():Number
    {
      return _height || container.height;
    }
    
    public function set height(value:Number):void
    {
      _height = value;
    }
    
    public function hasLine(line:TextLine):Boolean
    {
      var child:DisplayObject;
      var n:int = container.numChildren;
      
      for(var i:int = 0; i < n; i++)
      {
        child = container.getChildAt(i);
        if(child === line)
          return true;
      }
      
      return false;
    }
    
    protected var calcHeight:Number = 0;
    public function layout(block:TextBlock, line:TextLine):TextLine
    {
      line = createLine(block, line);
      var doc:DisplayObjectContainer;
      
      var props:LayoutProperties = getLayoutProperties(block) || new LayoutProperties();
      
      if(props.textAlign == TextAlign.JUSTIFY)
        block.textJustifier = new SpaceJustifier("en", LineJustification.ALL_BUT_LAST, true);
      
      while(line)
      {
        line.userData = engine;
        
        doc = hookLine(line);
        
        doc.y = calcHeight;
        
        container.addChild(doc);
        
        calcHeight += doc.height + props.lineHeight;
        
        line = createLine(block, line);
        
        if(!isNaN(_height) && calcHeight > height)
        {
          calcHeight = 0;
          return line;
        }
      }
      
      return line;
    }
    
    protected function createLine(block:TextBlock, line:TextLine = null):TextLine
    {
      var props:LayoutProperties = getLayoutProperties(block) || new LayoutProperties();
      
      var w:Number = width || props.width;
      var x:Number = 0;
      
      if(line == null)
      {
        w -= props.textIndent;
        x += props.textIndent;
      }
      
      w -= props.paddingLeft;
      w -= props.paddingRight;
      
      line = block.createTextLine(line, w);
      
      if(!line)
        return null;
      
      switch(props.textAlign)
      {
        case TextAlign.LEFT:
        case TextAlign.JUSTIFY:
          x += props.paddingLeft;
          break;
        case TextAlign.CENTER:
          x = (width - line.width) * 0.5;
          break;
        case TextAlign.RIGHT:
          x = width - line.width + props.paddingRight;
          break;
      }
      
      line.x = x;
      
      return line;
    }
    
    protected function hookLine(line:TextLine):DisplayObjectContainer
    {
      return line;
    }
    
    protected function getLayoutProperties(block:TextBlock):LayoutProperties
    {
      return engine.styler.getMappedStyle(block) as LayoutProperties;
    }
  }
}