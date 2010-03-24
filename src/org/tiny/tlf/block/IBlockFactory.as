package org.tiny.tlf.block
{
  import flash.text.engine.ContentElement;
  import flash.text.engine.TextBlock;
  
  import org.tiny.tlf.ITextContainer;
  import org.tiny.tlf.decoration.ITextDecorator;
  import org.tiny.tlf.interaction.ITextInteractor;
  import org.tiny.tlf.styles.ITextStyler;

  public interface IBlockFactory
  {
    function get container():ITextContainer;
    function set container(textContainer:ITextContainer):void;
    
    function get data():*;
    function set data(value:*):void;
    
    function get decorator():ITextDecorator;
    function set decorator(textDecorator:ITextDecorator):void;
    
    function get interactor():ITextInteractor;
    function set interactor(textInteractor:ITextInteractor):void;
    
    function get styler():ITextStyler;
    function set styler(textStyler:ITextStyler):void;
    
    function get blocks():Vector.<TextBlock>;
    function get elements():Vector.<ContentElement>;
    
    function createBlocks(...args):Vector.<TextBlock>;
    function createElements(...args):Vector.<ContentElement>;
  }
}