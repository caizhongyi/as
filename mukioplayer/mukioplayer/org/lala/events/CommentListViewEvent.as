package org.lala.events
{
    import flash.events.*;

    public class CommentListViewEvent extends Event
    {
        private var _data:Object;
        public static var FILTERADD:String = "filterAdd";
        public static var TRACKTOGGLE:String = "trackToggle";
        public static var FILTERCHECKBOXTOGGLE:String = "filterCheckBoxToggle";
        public static var POPOCOMMENTSEND:String = "popoCommentSend";
        public static var TBBUTTONCHANGE:String = "tabButtonStateChange";
        public static var COMMENTALPHA:String = "commentAlpha";
        public static var FILTERDELETE:String = "filterDelete";
        public static var PREVIEWCOMMENT:String = "previewComment";
        public static var FILTERLISTENABLETOGGLE:String = "filterListEnableToggle";
        public static var DISPLAYTOGGLE:String = "displayToggle";
        public static var SENDCOMMENT:String = "sendComment";
        public static var SENDPOPOCOMMENT:String = "sendPopoComment";
        public static var COLDTRICKER:String = "coldTriker";
        public static var MODESTYLESIZECHANGE:String = "modeStyleSizeChange";

        public function CommentListViewEvent(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false)
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
