package org.tinytlf.layout
{
  import flash.text.engine.TextBlock;
  
  import org.tinytlf.ITextEngine;

  public interface ITextLayout
  {
    function get engine():ITextEngine;
    function set engine(textEngine:ITextEngine):void;
    
    function render(blocks:Vector.<TextBlock>, containers:Vector.<ITextContainer>):void;
  }
}