package org.tinytlf.layout
{
  import flash.text.engine.TextBlock;
  import flash.text.engine.TextLine;
  import flash.utils.Dictionary;
  
  import org.tinytlf.ITextEngine;
  import org.tinytlf.layout.view.ITextContainer;
  
  public class TextLayoutBase implements ITextLayout
  {
    public function TextLayoutBase()
    {
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
    
    public function render(blocks:Vector.<TextBlock>):void
    {
      if(!_containers)
        throw new Error('ITextLayout needs containers to render on.');
      
      var blockIndex:int = 0;
      var containerIndex:int = 0;
      
      var block:TextBlock = blocks[0];
      var container:ITextContainer = _containers[0];
      var line:TextLine;
      
      while(blockIndex < blocks.length)
      {
        block = blocks[blockIndex];
        container = _containers[containerIndex];
        
        line = container.layout(block, line);
        
        if(line)
          container = _containers[++containerIndex];
        else if(++blockIndex < blocks.length)
          block = blocks[blockIndex];
        else
          return;
      }
    }
    
    protected var _containers:Vector.<ITextContainer> = new Vector.<ITextContainer>();
    
    public function get containers():Vector.<ITextContainer>
    {
      return _containers.concat();
    }
    
    public function addContainer(container:ITextContainer):void
    {
      if(_containers.indexOf(container) != -1)
        return;
      
      _containers.push(container);
      container.engine = engine;
    }
    
    public function removeContainer(container:ITextContainer):void
    {
      var i:int = _containers.indexOf(container);
      if(i == -1)
        return;
      
      _containers.splice(i, 1);
      container.engine = null;
    }
    
    public function getContainerForLine(line:TextLine):ITextContainer
    {
      var n:int = _containers.length;
      
      for(var i:int = 0; i < n; i++)
      {
        if(_containers[i].hasLine(line))
          return _containers[i];
      }
      
      return null;
    }
    
    protected var propertiesMap:Dictionary = new Dictionary(true);
    
    public function getLayoutProperties(block:TextBlock):LayoutProperties
    {
      return propertiesMap[block];
    }
    
    public function mapLayoutProperties(block:TextBlock, properties:LayoutProperties):void
    {
      propertiesMap[block] = properties;
    }
    
    public function unMapLayoutProperties(block:TextBlock):Boolean
    {
      if(!(block in propertiesMap))
        return false;
      
      return delete propertiesMap[block];
    }
  }
}