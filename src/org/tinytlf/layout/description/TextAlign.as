package org.tinytlf.layout.description
{
    public class TextAlign extends Enum
    {
        public function TextAlign(identifier:String)
        {
            super(id);
        }
        
        public static const LEFT:TextAlign = new TextAlign("left");
        public static const CENTER:TextAlign = new TextAlign("center");
        public static const RIGHT:TextAlign = new TextAlign("right");
        public static const JUSTIFY:TextAlign = new TextAlign("justify");
    }
}

