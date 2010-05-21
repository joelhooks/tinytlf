package org.tinytlf.block
{
  import org.tinytlf.ITextEngine;
  
  import flash.text.engine.ContentElement;
  import flash.text.engine.TextBlock;

  public interface IBlockFactory
  {
    function get engine():ITextEngine;
    function set engine(textEngine:ITextEngine):void;
    
    function get data():Object;
    function set data(value:Object):void;
    
    function get blocks():Vector.<TextBlock>;
    function get elements():Vector.<ContentElement>;
    
    function createBlocks(...args):Vector.<TextBlock>;
    function createElements(...args):Vector.<ContentElement>;
  }
}