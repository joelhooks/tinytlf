package org.tinytlf.block
{
  import org.tinytlf.ITextEngine;
  
  import flash.text.engine.ContentElement;
  import flash.text.engine.TextBlock;
  
  public class AbstractBlockFactory implements IBlockFactory
  {
    public static const WHITE_SPACE:String  = "whitespace";
    public static const GENERIC_TEXT:String = "text";
    
    public function AbstractBlockFactory()
    {
    }
    
    private var _engine:ITextEngine;
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
    
    protected var _blocks:Vector.<TextBlock>;
    public function get blocks():Vector.<TextBlock>
    {
      return _blocks.concat();
    }
    
    protected var _elements:Vector.<ContentElement>;
    public function get elements():Vector.<ContentElement>
    {
      return _elements.concat();
    }
    
    private var _data:*;
    public function get data():Object
    {
      return _data;
    }
    
    public function set data(value:Object):void
    {
      if(value == _data)
        return;
      
      _data = value;
    }
    
    public function createBlocks(...args):Vector.<TextBlock>
    {
      if(_blocks != null)
      {
        var block:TextBlock;
        while(_blocks.length > 0)
        {
          block = _blocks.pop();
          block.releaseLines(block.firstLine, block.lastLine);
        }
      }
      else
      {
        _blocks = new Vector.<TextBlock>();
      }
      
      var elements:Vector.<ContentElement> = createElements.apply(null, args);
      
      while(elements.length > 0)
        _blocks.push(executeBlockHooks(new TextBlock(elements.shift())));
        
      return _blocks;
    }
    
    public function createElements(...args):Vector.<ContentElement>
    {
      return _elements = new Vector.<ContentElement>();
    }
    
    protected function executeBlockHooks(block:TextBlock):TextBlock
    {
      return block;
    }
  }
}