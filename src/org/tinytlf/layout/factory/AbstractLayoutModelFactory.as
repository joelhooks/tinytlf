package org.tinytlf.layout.factory
{
  import org.tinytlf.ITextEngine;
  import org.tinytlf.layout.adapter.ContentElementAdapter;
  import org.tinytlf.layout.adapter.IContentElementAdapter;
  import org.tinytlf.layout.adapter.ITextBlockAdapter;
  import org.tinytlf.layout.adapter.TextBlockAdapter;
  
  import flash.text.engine.ContentElement;
  import flash.text.engine.TextBlock;
  import flash.utils.Dictionary;
  
  public class AbstractLayoutModelFactory implements ILayoutModelFactory
  {
    public static const WHITE_SPACE:String = "whitespace";
    public static const GENERIC_TEXT:String = "text";
    
    private var _blockAdapter:ITextBlockAdapter;
    
    public function get blockAdapter():ITextBlockAdapter
    {
      if(!_blockAdapter)
      {
        _blockAdapter = new TextBlockAdapter();
        _blockAdapter.engine = engine;
      }
      
      return _blockAdapter;
    }
    
    public function set blockAdapter(adapter:ITextBlockAdapter):void
    {
      if(adapter === _blockAdapter)
        return;
      
      _blockAdapter = adapter;
      _blockAdapter.engine = engine;
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
    
    public function createBlocks(... args):Vector.<TextBlock>
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
        _blocks.push(blockAdapter.execute(elements.shift()));
      
      return _blocks;
    }
    
    public function createElements(... args):Vector.<ContentElement>
    {
      return _elements = new Vector.<ContentElement>();
    }
    
    protected var elementAdapterMap:Dictionary = new Dictionary(false);
    
    public function getElementAdapter(element:*):IContentElementAdapter
    {
      var adapter:*;
      
      //Return the generic adapter if we haven't mapped any.
      if(!(element in elementAdapterMap))
      {
        adapter = new ContentElementAdapter();
        IContentElementAdapter(adapter).engine = engine;
        return adapter;
      }
      
      adapter = elementAdapterMap[element];
      if(adapter is Class)
        adapter = IContentElementAdapter(new (adapter as Class)());
      if(adapter is Function)
        adapter = IContentElementAdapter((adapter as Function)());
      
      IContentElementAdapter(adapter).engine = engine;
      
      return IContentElementAdapter(adapter);
    }
    
    public function mapElementAdapter(element:*, adapterClassOrInstance:Object):void
    {
      elementAdapterMap[element] = adapterClassOrInstance;
    }
    
    public function unMapElementAdapter(element:*):Boolean
    {
      if(!(element in elementAdapterMap))
        return false;
      
      return delete elementAdapterMap[element];
    }
  }
}