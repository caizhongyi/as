package com.jeroenwijering.events
{
    import flash.events.*;

    public class SPLoaderEvent extends Event
    {
        public static var PLUGINS:String = "PLUGINS";
        public static var SKIN:String = "SKIN";

        public function SPLoaderEvent(param1:String, param2:Boolean = false, param3:Boolean = false) : void
        {
            super(param1, param2, param3);
            return;
        }// end function

    }
}
