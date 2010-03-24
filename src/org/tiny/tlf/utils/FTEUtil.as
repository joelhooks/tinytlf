package org.tiny.tlf.utils
{
  import flash.geom.Point;
  import flash.text.engine.ContentElement;
  import flash.text.engine.GroupElement;
  import flash.text.engine.TextLine;
  
  public class FTEUtil
  {
    public static function getContentElementAt(element:ContentElement, index:int):ContentElement
    {
      var idx:int = index;
      while(element is GroupElement)
      {
        idx = index - element.textBlockBeginIndex;
        idx = (idx <= 0) ? 1 : (idx < element.rawText.length) ? idx : element.rawText.length - 1
        if(idx < Math.max(element.rawText.length, GroupElement(element).elementCount))
          element = GroupElement(element).getElementAtCharIndex(idx);
        else
          break;
      }
      
      return element;
    }
    
    public static function getAtomIndexAtPoint(stageX:Number, stageY:Number, line:TextLine):int
    {
      var atomIndex:int = line.getAtomIndexAtPoint(stageX, stageY);
      if(atomIndex == -1)
        return -1;
      
      var atomCenter:int = line.getAtomCenter(atomIndex);
      var atomIncrement:int = (line.localToGlobal(new Point(atomCenter, 0)).x <= stageX) ? 1 : 0;
      
      return line.getAtomTextBlockBeginIndex(atomIndex) + atomIncrement;
    }
  
  }
}