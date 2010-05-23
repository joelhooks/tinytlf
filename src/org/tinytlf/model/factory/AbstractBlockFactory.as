package org.tinytlf.model.factory
{
  import flash.text.engine.ContentElement;
  import flash.text.engine.TextBlock;
  import flash.utils.Dictionary;
  
  import mx.core.IFactory;
  
  import org.tinytlf.ITextEngine;
  import org.tinytlf.model.adapter.IModelAdapter;
  import org.tinytlf.model.adapter.ContentElementAdapter;
  
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
    
    protected var adapterMap:Dictionary = new Dictionary(false);
    
    public function getModelAdapter(element:*):IModelAdapter
    {
      var adapter:*;
      
      //Return the generic adapter if we haven't mapped any.
      if(!(element in adapterMap))
      {
        adapter = new ContentElementAdapter();
        IModelAdapter(adapter).engine = engine;
        return adapter;
      }
      
      adapter = adapterMap[element];
      if(adapter is IFactory)
        adapter = IModelAdapter(IFactory(adapter).newInstance());
      if(adapter is Class)
        adapter = IModelAdapter(new adapter());
      if(adapter is Function)
        adapter = IModelAdapter((adapter as Function)());
      
      IModelAdapter(adapter).engine = engine;
      
      return IModelAdapter(adapter);
    }
    
    public function mapModelAdapter(element:*, adapterClassOrInstance:Object):void
    {
      adapterMap[element] = adapterClassOrInstance;
    }
    
    public function unMapModelAdapter(element:*):Boolean
    {
      if(!(element in adapterMap))
        return false;
      
      return delete adapterMap[element];
    }
  }
}