package org.tiny.tlf.decoration
{
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.text.engine.TextLine;

  public class SelectionDecoration extends BackgroundColorDecoration
  {
    public function SelectionDecoration()
    {
      super(".textSelectionStyle");
    }
    
    override public function setup(...args):Vector.<Rectangle>
    {
      var bounds:Vector.<Rectangle> = super.setup();
      
      if(args.length != 3)
        return bounds;
      
      var selection:Point = args[0];
      var startLine:TextLine = args[1];
      var endLine:TextLine = args[2];
      
      if(!selection || !startLine || !endLine)
        return bounds;
      
      var start:int;
      var end:int;
      var startBounds:Rectangle;
      var endBounds:Rectangle;
      var finalBounds:Rectangle;
      
      var right:Boolean = selection.x <= selection.y;
      
      // Selection within the same line
      if(startLine == endLine)
      {
        start = selection.x;
        end = selection.y;
        
        if(!right)
          start--;
        
        startBounds = startLine.getAtomBounds(startLine.getAtomIndexAtCharIndex(start));
        endBounds = startLine.getAtomBounds(startLine.getAtomIndexAtCharIndex(end));
        
        finalBounds = startBounds.union(endBounds);
        finalBounds.x += startLine.x;
        finalBounds.y += startLine.y;
        
        bounds.push(finalBounds);
      }
      // Selection between lines
      else
      {
        if(right)
        {
          start = selection.x;
          end = startLine.textBlockBeginIndex + startLine.rawTextLength - 1;
        }
        else
        {
          start = selection.x - 1;
          end = startLine.textBlockBeginIndex;
        }
        
        startBounds = startLine.getAtomBounds(startLine.getAtomIndexAtCharIndex(start));
        endBounds = startLine.getAtomBounds(startLine.getAtomIndexAtCharIndex(end));
        
        finalBounds = startBounds.union(endBounds);
        finalBounds.x += startLine.x;
        finalBounds.y += startLine.y;
        
        bounds.push(finalBounds);
        
        var line:TextLine = startLine;
        while(true)
        {
          line = right ? line.nextLine : line.previousLine;
          if(line == endLine || line == null)
            break;
          
          finalBounds = line.getBounds(line);
          finalBounds.x += line.x;
          finalBounds.y += line.y;
          
          bounds.push(finalBounds);
        }
        
        if(right)
        {
          start = endLine.textBlockBeginIndex;
          end = selection.y;
        }
        else
        {
          start = endLine.textBlockBeginIndex + endLine.rawTextLength - 1;
          end = selection.y;
        }
        
        startBounds = endLine.getAtomBounds(endLine.getAtomIndexAtCharIndex(start));
        endBounds = endLine.getAtomBounds(endLine.getAtomIndexAtCharIndex(end));
        
        finalBounds = startBounds.union(endBounds);
        finalBounds.x += endLine.x;
        finalBounds.y += endLine.y;
        
        bounds.push(finalBounds);
      }
      
      return bounds;
    }
  }
}