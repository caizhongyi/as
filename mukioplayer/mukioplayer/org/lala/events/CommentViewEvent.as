package org.lala.events
{
    import flash.events.*;

    public class CommentViewEvent extends Event
    {
        private var _data:Object;
        public static var TIMER:String = "timer";
        public static var FILTERADD:String = "filterAdd";
        public static var TRACK:String = "track";
        public static var FILTEINITIAL:String = "filterInitial";
        public static var PLAY:String = "play";
        public static var PAUSE:String = "pause";
        public static var RESIZE:String = "resize";
        public static var TRACKTOGGLE:String = "trackToggle";

        public function CommentViewEvent(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false)
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
