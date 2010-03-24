package org.tiny.tlf.block
{
  import flash.text.engine.ContentElement;
  import flash.text.engine.TextBlock;
  
  import org.tiny.tlf.ITextContainer;
  import org.tiny.tlf.decoration.ITextDecorator;
  import org.tiny.tlf.decoration.TextDecorator;
  import org.tiny.tlf.interaction.ITextInteractor;
  import org.tiny.tlf.interaction.TextInteractorBase;
  import org.tiny.tlf.styles.ITextStyler;
  import org.tiny.tlf.styles.TextStyler;
  
  public class AbstractBlockFactory implements IBlockFactory
  {
    public function AbstractBlockFactory()
    {
    }
    
    private var _container:ITextContainer;
    public function get container():ITextContainer
    {
      return _container;
    }
    
    public function set container(textContainer:ITextContainer):void
    {
      if(textContainer == _container)
        return;
      
      _container = textContainer;
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
    public function get data():*
    {
      return _data;
    }
    
    public function set data(value:*):void
    {
      if(value == _data)
        return;
      
      _data = value;
    }
    
    private var _decorator:ITextDecorator;
    public function get decorator():ITextDecorator
    {
      if(!_decorator)
        decorator = new TextDecorator();
      
      return _decorator;
    }
    
    public function set decorator(textDecorator:ITextDecorator):void
    {
      if(textDecorator == _decorator)
        return;
      
      _decorator = textDecorator;
      decorator.blockFactory = this;
    }
    
    private var _interactor:ITextInteractor;
    public function get interactor():ITextInteractor
    {
      if(!_interactor)
        interactor = new TextInteractorBase();
      
      return _interactor;
    }
    
    public function set interactor(textInteractor:ITextInteractor):void
    {
      if(textInteractor == _interactor)
        return;
      
      _interactor = textInteractor;
      interactor.blockFactory = this;
    }
    
    private var _styler:ITextStyler;
    public function get styler():ITextStyler
    {
      if(!_styler)
        styler = new TextStyler();
      
      return _styler;
    }
    
    public function set styler(textStyler:ITextStyler):void
    {
      if(textStyler === _styler)
        return;
      
      _styler = textStyler;
      styler.blockFactory = this;
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
      
      _elements = createElements.apply(null, args);
      var e:Vector.<ContentElement> = elements;
      
      while(e.length > 0)
        _blocks.push(new TextBlock(e.shift()));
        
      return _blocks;
    }
    
    public function createElements(...args):Vector.<ContentElement>
    {
      return new Vector.<ContentElement>();
    }
  }
}