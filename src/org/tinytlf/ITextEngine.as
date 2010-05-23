package org.tinytlf
{
  import flash.text.engine.TextLine;
  
  import org.tinytlf.model.factory.IBlockFactory;
  import org.tinytlf.decor.ITextDecor;
  import org.tinytlf.interaction.ITextInteractor;
  import org.tinytlf.layout.ITextContainer;
  import org.tinytlf.layout.ITextLayout;
  import org.tinytlf.styles.ITextStyler;

  public interface ITextEngine
  {
    function get blockFactory():IBlockFactory;
    function set blockFactory(value:IBlockFactory):void;
    
    function get decor():ITextDecor;
    function set decor(textDecor:ITextDecor):void;
    
    function get interactor():ITextInteractor;
    function set interactor(textInteractor:ITextInteractor):void;
    
    function get layout():ITextLayout;
    function set layout(textlayout:ITextLayout):void;
    
    function get styler():ITextStyler;
    function set styler(textStyler:ITextStyler):void;
    
    function prerender(...args):void;
    
    function invalidate():void;
    function invalidateLines():void;
    function invalidateDecorations():void;
    
    function render():void;
    function renderLines():void;
    function renderDecorations():void;
  }
}