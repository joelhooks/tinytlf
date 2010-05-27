package org.tinytlf.layout.model.factory
{
  import flash.text.engine.ContentElement;
  import flash.text.engine.TextBlock;
  
  import org.tinytlf.ITextEngine;
  import org.tinytlf.layout.model.adapter.IContentElementAdapter;
  import org.tinytlf.layout.model.adapter.ITextBlockAdapter;
  
  /**
  * Ultimately the job of BlockFactory is to generate TextBlocks for us. It just
  * so happens that generating TextBlocks requires the generation of 
  * ContentElements as well. Thus this is the main model actor in tinyTLF.
  */
  public interface ILayoutModelFactory
  {
    function get blockAdapter():ITextBlockAdapter;
    function set blockAdapter(adapter:ITextBlockAdapter):void;
    
    function get data():Object;
    function set data(value:Object):void;
    
    function get engine():ITextEngine;
    function set engine(textEngine:ITextEngine):void;
    
    function get blocks():Vector.<TextBlock>;
    function get elements():Vector.<ContentElement>;
    
    function createBlocks(...args):Vector.<TextBlock>;
    function createElements(...args):Vector.<ContentElement>;
    
    function getElementAdapter(element:*):IContentElementAdapter;
    function mapElementAdapter(element:*, adapterClassOrInstance:Object):void;
    function unMapElementAdapter(element:*):Boolean;
  }
}