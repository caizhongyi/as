package org.lala.models
{
    import flash.events.*;

    public class NSEvent extends Event
    {
        private var _$info:Object;
        private var _$type:String;
        public static const READY:String = "ready";
        public static const STOP:String = "stop";
        public static const LOAD_BREAK:String = "loadBreak";
        public static const PLAYING:String = "playing";
        public static const FULL:String = "full";
        public static const BUFFERING:String = "buffering";
        public static const CHECK_FULL:String = "checkfull";
        public static const SEEK_ERROR:String = "seekError";
        public static const FLUSH:String = "flush";
        public static const FILE_EMPTY:String = "fileEmpty";
        public static const META_DATA:String = "metaData";
        public static const EMPTY:String = "empty";
        public static const PLAY:String = "play";

        public function NSEvent(param1:String, param2:Object = 0)
        {
            super(param1);
            this._$type = param1;
            this._$info = param2;
            return;
        }// end function

        public function get info() : Object
        {
            return this._$info;
        }// end function

        override public function clone() : Event
        {
            return new NSEvent(this._$type, this._$info);
        }// end function

    }
}
