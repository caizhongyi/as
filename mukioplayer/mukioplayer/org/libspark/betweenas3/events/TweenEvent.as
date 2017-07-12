package org.libspark.betweenas3.events
{
    import flash.events.*;

    public class TweenEvent extends Event
    {
        public static const UPDATE:String = "update";
        public static const STOP:String = "stop";
        public static const COMPLETE:String = "complete";
        public static const PLAY:String = "play";

        public function TweenEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
        {
            super(param1, param2, param3);
            return;
        }// end function

    }
}
