/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.utils
{
    import flash.geom.Point;
    import flash.text.engine.ContentElement;
    import flash.text.engine.GroupElement;
    import flash.text.engine.TextLine;
    import flash.ui.Keyboard;
    
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
        
        public static function getAtomWordBoundary(line:TextLine, element:ContentElement, atomIndex:int, left:Boolean = true):int
        {
            var adjustedAtomIndex:int = atomIndex + line.textBlockBeginIndex;
            
            var atomCode:Number = element.rawText.charCodeAt(adjustedAtomIndex);
            
            if(atomCode === Keyboard.SPACE || (!left && atomIndex == 0))
            {
                left ? --atomIndex : ++atomIndex;
                adjustedAtomIndex = atomIndex + line.textBlockBeginIndex;
                atomCode = element.rawText.charCodeAt(adjustedAtomIndex);
            }
            
            if(left)
            {
                while(!isNaN(atomCode) && atomIndex > 0 && atomCode != Keyboard.SPACE && line.getAtomGraphic(adjustedAtomIndex) == null)
                {
                    atomCode = element.rawText.charCodeAt(--adjustedAtomIndex);
                    atomIndex--;
                }
            }
            else
            {
                while(!isNaN(atomCode) && atomIndex < element.rawText.length && atomCode != Keyboard.SPACE && line.getAtomGraphic(adjustedAtomIndex) == null)
                {
                    atomCode = element.rawText.charCodeAt(++adjustedAtomIndex);
                    atomIndex++;
                }
            }
            
            return atomIndex;
        }
        
        /**
         *  Returns true if all of the flags specified by <code>flagMask</code> are set.
         */
        public static function isBitSet(flags:uint, flagMask:uint):Boolean
        {
            return flagMask == (flags & flagMask);
        }
        
        /**
         *  Sets the flags specified by <code>flagMask</code> according to <code>value</code>.
         *  Returns the new bitflag.
         *  <code>flagMask</code> can be a combination of multiple flags.
         */
        public static function updateBits(flags:uint, flagMask:uint, update:Boolean = true):uint
        {
            if(update)
            {
                if((flags & flagMask) == flagMask)
                    return flags; // Nothing to change
                // Don't use ^ since flagMask could be a combination of multiple flags
                flags |= flagMask;
            }
            else
            {
                if((flags & flagMask) == 0)
                    return flags; // Nothing to change
                // Don't use ^ since flagMask could be a combination of multiple flags
                flags &= ~flagMask;
            }
            return flags;
        }
    }
}

