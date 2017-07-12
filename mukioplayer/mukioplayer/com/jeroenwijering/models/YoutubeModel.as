package com.jeroenwijering.models
{
    import com.jeroenwijering.events.*;
    import com.jeroenwijering.player.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;

    public class YoutubeModel extends AbstractModel
    {
        private var connected:Boolean;
        private var loader:Loader;
        private var unique:String;
        private var outgoing:LocalConnection;
        private var inbound:LocalConnection;
        private var loading:Boolean;

        public function YoutubeModel(param1:Model) : void
        {
            super(param1);
            Security.allowDomain("*");
            this.outgoing = new LocalConnection();
            this.outgoing.allowDomain("*");
            this.outgoing.allowInsecureDomain("*");
            this.outgoing.addEventListener(StatusEvent.STATUS, this.onLocalConnectionStatusChange);
            this.inbound = new LocalConnection();
            this.inbound.allowDomain("*");
            this.inbound.allowInsecureDomain("*");
            this.inbound.addEventListener(StatusEvent.STATUS, this.onLocalConnectionStatusChange);
            this.inbound.client = this;
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
            addChild(this.loader);
            return;
        }// end function

        public function onStateChange(param1:Number) : void
        {
            switch(Number(param1))
            {
                case 0:
                {
                    if (model.config["state"] != ModelStates.BUFFERING && model.config["state"] != ModelStates.IDLE)
                    {
                        model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.COMPLETED});
                    }
                    break;
                }
                case 1:
                {
                    model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PLAYING});
                    break;
                }
                case 2:
                {
                    model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PAUSED});
                    break;
                }
                case 3:
                {
                    model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.BUFFERING});
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        override public function resize() : void
        {
            this.outgoing.send("AS3_" + this.unique, "setSize", model.config["width"], model.config["height"]);
            return;
        }// end function

        public function onSwfLoadComplete() : void
        {
            if (model.config["mute"] == true)
            {
                this.volume(0);
            }
            else
            {
                this.volume(model.config["volume"]);
            }
            this.connected = true;
            if (this.loading)
            {
                this.load(item);
            }
            return;
        }// end function

        override public function stop() : void
        {
            if (this.connected)
            {
                this.outgoing.send("AS3_" + this.unique, "stopVideo");
            }
            else
            {
                this.loading = false;
            }
            position = 0;
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.IDLE});
            return;
        }// end function

        public function onTimeChange(param1:Number, param2:Number) : void
        {
            model.sendEvent(ModelEvent.TIME, {position:param1, duration:param2});
            if (!item["duration"])
            {
                item["duration"] = param2;
            }
            return;
        }// end function

        override public function volume(param1:Number) : void
        {
            this.outgoing.send("AS3_" + this.unique, "setVolume", param1);
            return;
        }// end function

        private function errorHandler(event:ErrorEvent) : void
        {
            this.stop();
            model.sendEvent(ModelEvent.ERROR, {message:event.text});
            return;
        }// end function

        private function getLocation() : String
        {
            var _loc_1:String = null;
            var _loc_2:* = loaderInfo.url;
            if (_loc_2.indexOf("http://") == 0)
            {
                this.unique = Math.random().toString().substr(2);
                _loc_1 = _loc_2.substr(0, _loc_2.indexOf(".swf"));
                _loc_1 = _loc_1.substr(0, (_loc_1.lastIndexOf("/") + 1)) + "yt.swf?unique=" + this.unique;
            }
            else
            {
                this.unique = "1";
                _loc_1 = "yt.swf";
            }
            return _loc_1;
        }// end function

        override public function load(param1:Object) : void
        {
            var _loc_2:String = null;
            item = param1;
            position = 0;
            this.loading = true;
            if (this.connected)
            {
                _loc_2 = this.getID(item["file"]);
                this.outgoing.send("AS3_" + this.unique, "loadVideoById", _loc_2, item["start"]);
                this.resize();
            }
            else
            {
                this.loader.load(new URLRequest(this.getLocation()));
                this.inbound.connect("AS2_" + this.unique);
            }
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.BUFFERING});
            return;
        }// end function

        public function onError(param1:Number) : void
        {
            this.stop();
            var _loc_2:* = "Video not found or deleted: " + this.getID(item["file"]);
            if (param1 == 101 || param1 == 150)
            {
                _loc_2 = "Embedding this video is disabled by its owner.";
            }
            model.sendEvent(ModelEvent.ERROR, {message:_loc_2});
            return;
        }// end function

        private function getID(param1:String) : String
        {
            var _loc_4:String = null;
            var _loc_2:* = param1.split("?");
            var _loc_3:String = "";
            for (_loc_4 in _loc_2)
            {
                
                if (_loc_2[_loc_4].substr(0, 2) == "v=")
                {
                    _loc_3 = _loc_2[_loc_4].substr(2);
                }
            }
            if (_loc_3 == "")
            {
                _loc_3 = param1.substr(param1.indexOf("/v/") + 3);
            }
            if (_loc_3.indexOf("&") > -1)
            {
                _loc_3 = _loc_3.substr(0, _loc_3.indexOf("&"));
            }
            return _loc_3;
        }// end function

        override public function play() : void
        {
            this.outgoing.send("AS3_" + this.unique, "playVideo");
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PLAYING});
            return;
        }// end function

        public function onLoadChange(param1:Number, param2:Number, param3:Number) : void
        {
            model.sendEvent(ModelEvent.LOADED, {loaded:param1, total:param2, offset:param3});
            return;
        }// end function

        override public function pause() : void
        {
            this.outgoing.send("AS3_" + this.unique, "pauseVideo");
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PAUSED});
            return;
        }// end function

        public function onLocalConnectionStatusChange(event:StatusEvent) : void
        {
            return;
        }// end function

        override public function seek(param1:Number) : void
        {
            this.outgoing.send("AS3_" + this.unique, "seekTo", param1);
            this.play();
            return;
        }// end function

    }
}
