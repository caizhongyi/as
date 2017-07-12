package com.jeroenwijering.events
{
    import flash.events.*;

    public class ControllerEvent extends Event
    {
        private var _data:Object;
        public static var PLAYLIST:String = "PLAYLIST";
        public static var ERROR:String = "ERROR";
        public static var STOP:String = "STOP";
        public static var ITEM:String = "ITEM";
        public static var PLAY:String = "PLAY";
        public static var SEEK:String = "SEEK";
        public static var MUTE:String = "MUTE";
        public static var VOLUME:String = "VOLUME";
        public static var RESIZE:String = "RESIZE";

        public function ControllerEvent(param1:String, param2:Object = , param3:Boolean = false, param4:Boolean = false) : void
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
