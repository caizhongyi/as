package org.lala.utils
{
    import flash.events.*;
    import flash.net.*;
    import org.lala.events.*;

    public class Fms extends EventDispatcher
    {
        private var path:String = "rtmp://173.230.145.176/mukioplayer";
        private var myShared:SharedObject;
        private var nc:NetConnection;
        private var username:String = "";
        private var roomID:String = "";

        public function Fms(param1:Object)
        {
            return;
        }// end function

        public function sendMsg(param1:Object) : void
        {
            return;
        }// end function

        public function init(param1:Object) : void
        {
            dispatchEvent(new FmsEvent(FmsEvent.ACCEPT_ADDRESS, param1));
            return;
        }// end function

        private function statusHandler(event:NetStatusEvent) : void
        {
            trace("event.info.code : " + event.info.code);
            if (event.info.code == "NetConnection.Connect.Success")
            {
                this.myShared = SharedObject.getRemote("chat", this.nc.uri, false);
                this.myShared.connect(this.nc);
                this.myShared.client = this;
                dispatchEvent(new FmsEvent(FmsEvent.COMPLETE));
            }
            return;
        }// end function

        public function showChat(param1:Object) : void
        {
            dispatchEvent(new FmsEvent(FmsEvent.ACCEPTMSG, param1));
            return;
        }// end function

    }
}
