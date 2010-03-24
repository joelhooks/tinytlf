package org.tiny.tlf.decoration
{
  import flash.geom.Rectangle;
  import flash.text.engine.ContentElement;
  import flash.text.engine.TextLineMirrorRegion;

  public class ElementDecoration extends TextDecoration
  {
    public function ElementDecoration(styleName:String="")
    {
      super(styleName);
    }
    
    override public function setup(...args):Vector.<Rectangle>
    {
      var bounds:Vector.<Rectangle> = super.setup.apply(null, args);
      
      if(args.length <= 0)
        return bounds;
      
      var element:ContentElement = args[0] as ContentElement;
      if(element == null)
        return bounds;
      
      var regions:Vector.<TextLineMirrorRegion> = getMirrorRegions(element);
      if(regions.length <= 0)
        return bounds;
      
      var region:TextLineMirrorRegion;
      
      while(regions.length > 0)
      {
        region = regions.pop();
        bounds.push(new Rectangle(region.bounds.x + region.textLine.x, region.bounds.y + region.textLine.y, region.bounds.width, region.bounds.height));
      }
      
      return bounds;
    }
  }
}
