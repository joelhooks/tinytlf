package org.tiny.tlf.interaction
{
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  
  import org.tiny.tlf.block.IBlockFactory;
  import org.tiny.tlf.interaction.gestures.IGesture;
  
  public class TextInteractorBase extends TextDispatcherBase implements ITextInteractor
  {
    public function TextInteractorBase()
    {
      super(null);
    }
    
    private var _blockFactory:IBlockFactory;
    public function get blockFactory():IBlockFactory
    {
      return _blockFactory;
    }
    
    public function set blockFactory(factory:IBlockFactory):void
    {
      if(factory == _blockFactory)
        return;
      
      _blockFactory = factory;
    }
    
    public function get dispatcher():EventDispatcher
    {
      return this;
    }
  }
}