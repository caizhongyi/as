package org.lala.events
{
    import flash.events.*;

    public class CommentDataManagerEvent extends Event
    {
        private var _dta:Object;
        public static var NEW:String = "new";
        public static var POPO_TOP_SUBTITLE:String = "subtitletop";
        public static var POPO_NORMAL:String = "normal";
        public static var POPO_THINK:String = "think";
        public static var NORMAL_ORANGE_FLOW_RTL:String = "3";
        public static var NORMAL_FLOW_LTR:String = "6";
        public static var BIG_BLUE_FLOW_RTL:String = "2";
        public static var NORMAL_FLOW_RTL:String = "1";
        public static var ADDONE:String = "addOne";
        public static var NORMAL_BOTTOM_DISPLAY:String = "4";
        public static var POPO_BOTTOM_SUBTITLE:String = "subtitlebottom";
        public static var SETDATA:String = "setData";
        public static var NORMAL_GREEN_TOP_DISPLAY:String = "5";
        public static var POPO_LOUD:String = "loud";

        public function CommentDataManagerEvent(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false)
        {
            super(param1, param3, param4);
            this._dta = param2;
            return;
        }// end function

        public function get data() : Object
        {
            return this._dta;
        }// end function

    }
}
