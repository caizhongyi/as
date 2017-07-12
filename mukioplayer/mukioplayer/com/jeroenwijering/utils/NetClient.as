package com.jeroenwijering.utils
{

    dynamic public class NetClient extends Object
    {
        private var callback:Object;

        public function NetClient(param1:Object) : void
        {
            this.callback = param1;
            return;
        }// end function

        public function onTextData(param1:Object) : void
        {
            this.forward(param1, "textdata");
            return;
        }// end function

        private function forward(param1:Object, param2:String) : void
        {
            var _loc_4:Object = null;
            param1["type"] = param2;
            var _loc_3:* = new Object();
            for (_loc_4 in param1)
            {
                
                _loc_3[_loc_4] = param1[_loc_4];
            }
            this.callback.onClientData(_loc_3);
            return;
        }// end function

        public function onImageData(param1:Object) : void
        {
            this.forward(param1, "imagedata");
            return;
        }// end function

        public function onCaption(param1:String, param2:Number) : void
        {
            this.forward({captions:param1, speaker:param2}, "caption");
            return;
        }// end function

        public function onLastSecond(param1:Object) : void
        {
            this.forward(param1, "lastsecond");
            return;
        }// end function

        public function onXMPData(... args) : void
        {
            this.forward(args[0], "xmp");
            return;
        }// end function

        public function onFCSubscribe(param1:Object) : void
        {
            this.forward(param1, "fcsubscribe");
            return;
        }// end function

        public function onMetaData(param1:Object) : void
        {
            this.forward(param1, "metadata");
            return;
        }// end function

        public function onPlayStatus(param1:Object) : void
        {
            if (param1.code == "NetStream.Play.Complete")
            {
                this.forward(param1, "complete");
            }
            else
            {
                this.forward(param1, "playstatus");
            }
            return;
        }// end function

        public function onBWCheck(... args) : Number
        {
            return 0;
        }// end function

        public function onCaptionInfo(param1:Object) : void
        {
            this.forward(param1, "captioninfo");
            return;
        }// end function

        public function onBWDone(... args) : void
        {
            if (args.length > 0)
            {
                this.forward({bandwidth:args[0]}, "bandwidth");
            }
            return;
        }// end function

        public function close(... args) : void
        {
            this.forward({close:true}, "close");
            return;
        }// end function

        public function onID3(... args) : void
        {
            this.forward(args[0], "id3");
            return;
        }// end function

        public function RtmpSampleAccess(... args) : void
        {
            this.forward(args[0], "rtmpsampleaccess");
            return;
        }// end function

        public function onCuePoint(param1:Object) : void
        {
            this.forward(param1, "cuepoint");
            return;
        }// end function

        public function onHeaderData(param1:Object) : void
        {
            var _loc_5:String = null;
            var _loc_6:String = null;
            var _loc_2:* = new Object();
            var _loc_3:String = "-";
            var _loc_4:String = "_";
            for (_loc_5 in param1)
            {
                
                _loc_6 = _loc_5.replace("-", "_");
                _loc_2[_loc_6] = param1[_loc_5];
            }
            this.forward(_loc_2, "headerdata");
            return;
        }// end function

        public function onSDES(... args) : void
        {
            this.forward(args[0], "sdes");
            return;
        }// end function

    }
}
