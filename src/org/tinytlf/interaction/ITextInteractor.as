package org.tinytlf.interaction
{
    import org.tinytlf.ITextEngine;
    
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    
    public interface ITextInteractor extends IEventDispatcher
    {
        function get engine():ITextEngine;
        function set engine(textEngine:ITextEngine):void;
        
        /**
         * Returns an EventDispatcher for an element name. Typically an
         * IModelAdapter calls this when he is creating a ContentElement
         * and is ready to specify an eventMirror.
         */
        function getMirror(elementName:String = ""):EventDispatcher;
        
        /**
         * Maps a mirror class or instance to an elementName.
         * @return True if the mirror was successfully  mapped, False
         * if it wasn't.
         */
        function mapMirror(elementName:String, mirrorClassOrInstance:Object):void;
        /**
         * Unmaps the mirror class or instance for the given elementName.
         * @return True if the mirror was successfully  unmapped, or False
         * if it wasn't.
         */
        function unMapMirror(elementName:String):Boolean;
    }
}

