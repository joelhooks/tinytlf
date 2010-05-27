package org.tinytlf.layout.view.description
{
  public class Enum
  {
    public function Enum(identifier:String)
    {
      _id = identifier;
    }
    
    private var _id:String = "";
    public function get id():String
    {
      return _id;
    }
  }
}