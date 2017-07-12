package com.jeroenwijering.models
{
    import com.jeroenwijering.events.*;
    import com.jeroenwijering.player.*;
    import com.jeroenwijering.utils.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class RTMPModel extends AbstractModel
    {
        private var stream:NetStream;
        private var smil:String;
        private var loader:URLLoader;
        private var transformer:SoundTransform;
        private var bwinterval:Number;
        private var dynamics:Boolean;
        private var video:Video;
        private var timeoffset:Number = 0;
        private var interval:Number;
        private var bwswitch:Boolean = true;
        private var subscribe:Number;
        private var bwcheck:Boolean;
        private var connection:NetConnection;
        private var streaming:Boolean;
        private var transitioning:Boolean;

        public function RTMPModel(param1:Model) : void
        {
            super(param1);
            this.connection = new NetConnection();
            this.connection.addEventListener(NetStatusEvent.NET_STATUS, this.statusHandler);
            this.connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.errorHandler);
            this.connection.addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
            this.connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.errorHandler);
            this.connection.objectEncoding = ObjectEncoding.AMF0;
            this.connection.client = new NetClient(this);
            this.loader = new URLLoader();
            this.loader.addEventListener(Event.COMPLETE, this.loaderHandler);
            this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.errorHandler);
            this.loader.addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
            this.transformer = new SoundTransform();
            this.video = new Video(320, 240);
            this.video.smoothing = model.config["smoothing"];
            addChild(this.video);
            return;
        }// end function

        private function setStream() : void
        {
            this.stream = new NetStream(this.connection);
            this.stream.checkPolicyFile = true;
            this.stream.addEventListener(NetStatusEvent.NET_STATUS, this.statusHandler);
            this.stream.addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
            this.stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.errorHandler);
            this.stream.bufferTime = model.config["bufferlength"];
            this.stream.client = new NetClient(this);
            this.video.attachNetStream(this.stream);
            if (model.config["mute"] == true)
            {
                this.volume(0);
            }
            else
            {
                this.volume(model.config["volume"]);
            }
            this.seek(this.timeoffset);
            this.resize();
            return;
        }// end function

        private function streamlengthHandler(param1:Number) : void
        {
            if (param1 && !item["duration"])
            {
                item["duration"] = param1;
            }
            return;
        }// end function

        private function doSubscribe(param1:String) : void
        {
            this.connection.call("FCSubscribe", null, param1);
            return;
        }// end function

        override public function stop() : void
        {
            if (this.stream && this.stream.time)
            {
                this.stream.close();
            }
            this.streaming = false;
            this.connection.close();
            clearInterval(this.interval);
            clearInterval(this.bwinterval);
            position = 0;
            this.timeoffset = item["start"];
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.IDLE});
            if (this.smil)
            {
                item["file"] = this.smil;
            }
            return;
        }// end function

        private function positionInterval() : void
        {
            var _loc_1:* = Math.round(this.stream.time * 10) / 10;
            var _loc_2:* = this.stream.bufferLength / this.stream.bufferTime;
            if (_loc_2 < 0.5 && _loc_1 < item["duration"] - 5 && model.config["state"] != ModelStates.BUFFERING)
            {
                model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.BUFFERING});
                this.stream.bufferTime = model.config["bufferlength"];
            }
            else if (_loc_2 > 1 && model.config["state"] != ModelStates.PLAYING)
            {
                model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PLAYING});
                this.stream.bufferTime = model.config["bufferlength"] * 4;
            }
            if (_loc_1 < item["duration"])
            {
                if (_loc_1 != position)
                {
                    model.sendEvent(ModelEvent.TIME, {position:_loc_1, duration:item["duration"]});
                    position = _loc_1;
                }
            }
            else if (!isNaN(position) && item["duration"] > 0)
            {
                this.stream.pause();
                clearInterval(this.interval);
                if (this.stream && item["duration"] == 0)
                {
                    this.stop();
                }
                model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.COMPLETED});
            }
            return;
        }// end function

        private function checkDynamic(param1:String) : void
        {
            var _loc_2:* = Number(model.config["client"].split(" ")[2].split(",")[0]);
            var _loc_3:* = Number(param1.split(",")[0]);
            var _loc_4:* = Number(param1.split(",")[1]);
            if (_loc_2 > 9 && (_loc_3 > 3 || _loc_3 == 3 && _loc_4 > 4))
            {
                this.dynamics = true;
            }
            return;
        }// end function

        override public function volume(param1:Number) : void
        {
            this.transformer.volume = param1 / 100;
            if (this.stream)
            {
                this.stream.soundTransform = this.transformer;
            }
            return;
        }// end function

        private function swap() : void
        {
            var _loc_1:NetStreamPlayOptions = null;
            if (this.transitioning == true)
            {
                Logger.log("transition to level " + this.getLevel() + " cancelled");
            }
            else
            {
                this.transitioning = true;
                model.config["level"] = this.getLevel();
                Logger.log("transition to level " + this.getLevel() + " initiated");
                item["file"] = item["levels"][model.config["level"]].url;
                _loc_1 = new NetStreamPlayOptions();
                _loc_1.streamName = this.getID(item["file"]);
                _loc_1.transition = NetStreamPlayTransitions.SWITCH;
                this.stream.play2(_loc_1);
            }
            return;
        }// end function

        private function errorHandler(event:ErrorEvent) : void
        {
            this.stop();
            model.sendEvent(ModelEvent.ERROR, {message:event.text});
            return;
        }// end function

        private function getBW() : void
        {
            if (this.streaming)
            {
                this.connection.call("checkBandwidth", null);
            }
            return;
        }// end function

        override public function play() : void
        {
            this.stream.resume();
            this.interval = setInterval(this.positionInterval, 100);
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PLAYING});
            return;
        }// end function

        private function loaderHandler(event:Event) : void
        {
            var _loc_2:* = XML(event.currentTarget.data);
            item["streamer"] = _loc_2.children()[0].children()[0].@base.toString();
            item["file"] = _loc_2.children()[1].children()[0].@src.toString();
            this.connection.connect(item["streamer"]);
            return;
        }// end function

        override public function resize() : void
        {
            super.resize();
            if (item["levels"] && this.getLevel() != model.config["level"])
            {
                if (this.dynamics)
                {
                    this.swap();
                }
                else
                {
                    this.seek(position);
                }
            }
            return;
        }// end function

        private function getLevel() : Number
        {
            var _loc_1:* = item["levels"].length - 1;
            var _loc_2:Number = 0;
            while (_loc_2 < item["levels"].length)
            {
                
                if (model.config["width"] >= item["levels"][_loc_2].width && model.config["bandwidth"] >= item["levels"][_loc_2].bitrate)
                {
                    _loc_1 = _loc_2;
                    break;
                }
                _loc_2 = _loc_2 + 1;
            }
            return _loc_1;
        }// end function

        public function onClientData(param1:Object) : void
        {
            if (param1.type == "fcsubscribe")
            {
                if (param1.code == "NetStream.Play.StreamNotFound")
                {
                    model.sendEvent(ModelEvent.ERROR, {message:"Subscription failed: " + item["file"]});
                }
                else if (param1.code == "NetStream.Play.Start")
                {
                    this.setStream();
                }
                clearInterval(this.subscribe);
            }
            if (param1.width)
            {
                this.video.width = param1.width;
                this.video.height = param1.height;
                super.resize();
            }
            if (param1.duration && !item["duration"])
            {
                item["duration"] = param1.duration;
            }
            if (param1.type == "complete")
            {
                clearInterval(this.interval);
                model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.COMPLETED});
            }
            if (param1.type == "close")
            {
                this.stop();
            }
            if (param1.type == "bandwidth" && param1.bandwidth > 50)
            {
                model.config["bandwidth"] = param1.bandwidth;
            }
            if (param1.code == "NetStream.Play.TransitionComplete")
            {
                this.transitioning = false;
            }
            model.sendEvent(ModelEvent.META, param1);
            return;
        }// end function

        override public function load(param1:Object) : void
        {
            item = param1;
            position = 0;
            this.timeoffset = item["start"];
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.BUFFERING});
            if (model.config["rtmp.loadbalance"])
            {
                this.smil = item["file"];
                this.loader.load(new URLRequest(this.smil));
            }
            else
            {
                this.connection.connect(item["streamer"]);
            }
            return;
        }// end function

        private function getID(param1:String) : String
        {
            var _loc_2:* = param1.substr(-4);
            if (model.config["rtmp.prepend"] == false)
            {
                return param1;
            }
            if (_loc_2 == ".mp3")
            {
                return "mp3:" + param1.substr(0, param1.length - 4);
            }
            if (_loc_2 == ".mp4" || _loc_2 == ".mov" || _loc_2 == ".m4v" || _loc_2 == ".aac" || _loc_2 == ".m4a" || _loc_2 == ".f4v")
            {
                return "mp4:" + param1;
            }
            if (_loc_2 == ".flv")
            {
                return param1.substr(0, param1.length - 4);
            }
            return param1;
        }// end function

        override public function pause() : void
        {
            this.stream.pause();
            clearInterval(this.interval);
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PAUSED});
            if (this.stream && item["duration"] == 0 && !this.dynamics)
            {
                this.stop();
            }
            return;
        }// end function

        override public function seek(param1:Number) : void
        {
            position = 0;
            this.timeoffset = param1;
            this.transitioning = false;
            clearInterval(this.interval);
            clearInterval(this.bwinterval);
            this.interval = setInterval(this.positionInterval, 100);
            if (item["levels"] && this.getLevel() != model.config["level"])
            {
                model.config["level"] = this.getLevel();
                item["file"] = item["levels"][model.config["level"]].url;
            }
            if (model.config["state"] == ModelStates.PAUSED)
            {
                this.stream.resume();
            }
            if (model.config["rtmp.subscribe"])
            {
                this.stream.play(this.getID(item["file"]));
            }
            else
            {
                this.stream.play(this.getID(item["file"]));
                if (this.timeoffset)
                {
                    this.stream.seek(this.timeoffset);
                }
                if (this.dynamics)
                {
                    this.bwinterval = setInterval(this.getBandwidth, 2000);
                }
                else
                {
                    this.bwinterval = setInterval(this.getBW, 20000);
                }
            }
            this.streaming = true;
            return;
        }// end function

        private function getBandwidth() : void
        {
            try
            {
                model.config["bandwidth"] = Math.round(this.stream.info.maxBytesPerSecond * 8 / 1024);
            }
            catch (err:Error)
            {
                clearInterval(bwinterval);
            }
            if (item["levels"] && this.getLevel() != model.config["level"])
            {
                this.swap();
            }
            return;
        }// end function

        private function statusHandler(event:NetStatusEvent) : void
        {
            var msg:String;
            var evt:* = event;
            switch(evt.info.code)
            {
                case "NetConnection.Connect.Success":
                {
                    if (evt.info.secureToken != undefined)
                    {
                        this.connection.call("secureTokenResponse", null, TEA.decrypt(evt.info.secureToken, model.config["token"]));
                    }
                    if (evt.info.data)
                    {
                        this.checkDynamic(evt.info.data.version);
                    }
                    if (model.config["rtmp.subscribe"])
                    {
                        this.subscribe = setInterval(this.doSubscribe, 1000, this.getID(item["file"]));
                        return;
                    }
                    this.setStream();
                    if (!item["levels"])
                    {
                        this.connection.call("getStreamLength", new Responder(this.streamlengthHandler), this.getID(item["file"]));
                    }
                    break;
                }
                case "NetStream.Seek.Notify":
                {
                    clearInterval(this.interval);
                    this.interval = setInterval(this.positionInterval, 100);
                    break;
                }
                case "NetConnection.Connect.Rejected":
                {
                    try
                    {
                        if (evt.info.ex.code == 302)
                        {
                            item["streamer"] = evt.info.ex.redirect;
                            setTimeout(this.load, 100, item);
                            return;
                        }
                    }
                    catch (err:Error)
                    {
                        stop();
                        msg = evt.info.code;
                        if (evt.info["description"])
                        {
                            msg = evt.info["description"];
                        }
                        stop();
                        model.sendEvent(ModelEvent.ERROR, {message:msg});
                    }
                    break;
                }
                case "NetStream.Failed":
                case "NetStream.Play.StreamNotFound":
                {
                    if (!this.streaming)
                    {
                        this.onClientData({type:"complete"});
                    }
                    else
                    {
                        this.stop();
                        model.sendEvent(ModelEvent.ERROR, {message:"Stream not found: " + item["file"]});
                    }
                    break;
                }
                case "NetConnection.Connect.Failed":
                {
                    this.stop();
                    model.sendEvent(ModelEvent.ERROR, {message:"Server not found: " + item["streamer"]});
                    break;
                }
                case "NetStream.Play.UnpublishNotify":
                {
                    this.stop();
                    break;
                }
                default:
                {
                    break;
                }
            }
            model.sendEvent("META", evt.info);
            return;
        }// end function

    }
}
