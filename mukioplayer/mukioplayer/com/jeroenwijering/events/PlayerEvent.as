package com.jeroenwijering.events
{
    import flash.events.*;

    public class PlayerEvent extends Event
    {
        public static var READY:String = "READY";

        public function PlayerEvent(param1:String, param2:Boolean = false, param3:Boolean = false) : void
        {
            super(param1, param2, param3);
            return;
        }// end function

    }
}
