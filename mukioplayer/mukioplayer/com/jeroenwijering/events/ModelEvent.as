package com.jeroenwijering.events
{
    import flash.events.*;

    public class ModelEvent extends Event
    {
        private var _data:Object;
        public static var BUFFER:String = "BUFFER";
        public static var LOADED:String = "LOADED";
        public static var ERROR:String = "ERROR";
        public static var META:String = "META";
        public static var TIME:String = "TIME";
        public static var STATE:String = "STATE";

        public function ModelEvent(param1:String, param2:Object = , param3:Boolean = false, param4:Boolean = false) : void
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
