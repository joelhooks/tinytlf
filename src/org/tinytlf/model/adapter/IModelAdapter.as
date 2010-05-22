package org.tinytlf.model.adapter
{
  import flash.text.engine.ContentElement;
  
  import org.tinytlf.ITextEngine;

  public interface IModelAdapter
  {
    function get engine():ITextEngine;
    function set engine(textEngine:ITextEngine):void;
    
    function execute(data:Object, ...context:Array):ContentElement;
  }
}