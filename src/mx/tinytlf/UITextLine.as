package mx.tinytlf
{
  import flash.display.Graphics;
  import flash.events.EventDispatcher;
  import flash.events.MouseEvent;
  import flash.text.engine.TextLine;
  import flash.text.engine.TextLineMirrorRegion;
  
  import mx.core.UIComponent;
  
  import org.tinytlf.interaction.TextDispatcherBase;
  import org.tinytlf.utils.EventProxy;
  
  public class UITextLine extends UIComponent
  {
    public function UITextLine(line:TextLine = null)
    {
      this.line = line;
    }
    
    private var _line:TextLine;
    public function get line():TextLine
    {
      return _line;
    }
    
    public function set line(value:TextLine):void
    {
      if(value === _line)
        return;
      
      if(line)
        uninstallLine(line);
      
      _line = value;
      
      if(line)
        installLine(line);
    }
    
    protected function installLine(line:TextLine):void
    {
      width = line.width;
      line.y = height = line.height;
      
      if(line.mirrorRegions)
      {
        var regions:Vector.<TextLineMirrorRegion> = line.mirrorRegions.concat();
        var n:int = regions.length;
        var dispatcher:EventDispatcher;
        var proxy:EventProxy;
        
        for(var i:int = 0; i < n; i++)
        {
          dispatcher = regions[i].mirror;
          if(dispatcher is TextDispatcherBase)
            TextDispatcherBase(dispatcher).addListeners(this);
        }
      }
      
      addChild(line);
    }
    
    protected function uninstallLine(line:TextLine):void
    {
      if(contains(line))
        removeChild(line);
      
      graphics.clear();
    }
    
    override protected function updateDisplayList(w:Number, h:Number):void
    {
      super.updateDisplayList(w, h);
      
      // Draw a mouse catcher behind the TextLine so we can catch and proxy the 
      // "roll" events.
      var g:Graphics = graphics;
      g.clear();
      g.beginFill(0x00, 0);
      g.drawRect(line.x, 5, w, h);
    }
  }
}