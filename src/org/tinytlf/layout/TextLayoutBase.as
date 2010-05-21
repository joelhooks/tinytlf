package org.tinytlf.layout
{
  import flash.text.engine.TextBlock;
  import flash.text.engine.TextLine;
  
  import org.tinytlf.ITextEngine;
  
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
    
    public function render(blocks:Vector.<TextBlock>, containers:Vector.<ITextContainer>):void
    {
      if(!containers)
        throwNullContainerError();
      
      var blockIndex:int = 0;
      var containerIndex:int = 0;
      
      var block:TextBlock = blocks[0];
      var container:ITextContainer = containers[0];
      var line:TextLine;
      
      while(blockIndex < blocks.length)
      {
        block = blocks[blockIndex];
        container = containers[containerIndex];
        
        line = container.layout(block, line);
        
        if(line)
          container = containers[++containerIndex];
        else if(++blockIndex < blocks.length)
          block = blocks[blockIndex];
        else
          return;
      }
    }
    
    private function throwNullContainerError():void
    {
      throw new Error('ITextLayout needs containers to render on.');
    }
  }
}