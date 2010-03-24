package org.tiny.tlf.utils
{
  import flash.ui.Keyboard;
  
  public class KeyboardUtil
  {
    public static function isNavigable(keyCode:int):Boolean
    {
      return(
        isArrow(keyCode) ||
        isRemover(keyCode) ||
        isWhiteSpace(keyCode) ||
        isChar(keyCode)
      );
    }
    
    public static function isChar(keyCode:int):Boolean
    {
      return (!isModifier(keyCode) && !isRemover(keyCode));
    }
    
    public static function isModifier(keyCode:int):Boolean
    {
      return(
        keyCode == Keyboard.CAPS_LOCK ||
        keyCode == Keyboard.CONTROL ||
        keyCode == Keyboard.END ||
        keyCode == Keyboard.ESCAPE ||
        keyCode == Keyboard.HOME ||
        keyCode == Keyboard.INSERT ||
        keyCode == Keyboard.PAGE_DOWN ||
        keyCode == Keyboard.PAGE_UP ||
        keyCode == Keyboard.SHIFT ||
        isFunction(keyCode) ||
        isArrow(keyCode)
        );
    }
    
    public static function isWhiteSpace(keyCode:int):Boolean
    {
      return(
        keyCode == Keyboard.NUMPAD_ENTER ||
        keyCode == Keyboard.ENTER ||
        keyCode == Keyboard.TAB ||
        keyCode == Keyboard.SPACE
        );
    }
    
    public static function isArrow(keyCode:int):Boolean
    {
      return(
        keyCode == Keyboard.UP ||
        keyCode == Keyboard.DOWN ||
        keyCode == Keyboard.LEFT ||
        keyCode == Keyboard.RIGHT
        );
    }
    
    public static function isRemover(keyCode:int):Boolean
    {
      return(keyCode == Keyboard.BACKSPACE || keyCode == Keyboard.DELETE);
    }
    
    public static function isFunction(keyCode:int):Boolean
    {
      return(
        keyCode == Keyboard.F1 ||
        keyCode == Keyboard.F2 ||
        keyCode == Keyboard.F3 ||
        keyCode == Keyboard.F4 ||
        keyCode == Keyboard.F5 ||
        keyCode == Keyboard.F6 ||
        keyCode == Keyboard.F7 ||
        keyCode == Keyboard.F8 ||
        keyCode == Keyboard.F9 ||
        keyCode == Keyboard.F10 ||
        keyCode == Keyboard.F11 ||
        keyCode == Keyboard.F12 ||
        keyCode == Keyboard.F13 ||
        keyCode == Keyboard.F14 ||
        keyCode == Keyboard.F15
        );
    }
  }
}