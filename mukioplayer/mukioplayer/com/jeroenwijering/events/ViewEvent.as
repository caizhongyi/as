package com.jeroenwijering.events
{
    import flash.events.*;

    public class ViewEvent extends Event
    {
        private var _data:Object;
        public static var STOP:String = "STOP";
        public static var NEXT:String = "NEXT";
        public static var ITEM:String = "ITEM";
        public static var MUTE:String = "MUTE";
        public static var VOLUME:String = "VOLUME";
        public static var FULLSCREEN:String = "FULLSCREEN";
        public static var TRACE:String = "TRACE";
        public static var LOAD:String = "LOAD";
        public static var PREV:String = "PREV";
        public static var PLAY:String = "PLAY";
        public static var REDRAW:String = "REDRAW";
        public static var SEEK:String = "SEEK";
        public static var LINK:String = "LINK";

        public function ViewEvent(param1:String, param2:Object = , param3:Boolean = false, param4:Boolean = false) : void
        {
            super(param1, param3, param4);
            this._data = param2;
            return;
        }// end function

        public function get data() : Object
        {
            return this._data;
        }// end function

    }
}
