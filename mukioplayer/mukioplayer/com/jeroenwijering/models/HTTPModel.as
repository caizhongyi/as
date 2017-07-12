package com.jeroenwijering.models
{
    import com.jeroenwijering.events.*;
    import com.jeroenwijering.player.*;
    import com.jeroenwijering.utils.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class HTTPModel extends AbstractModel
    {
        private var interval:Number;
        private var stream:NetStream;
        private var bwswitch:Boolean = true;
        private var meta:Boolean;
        private var bwcheck:Boolean;
        private var keyframes:Object;
        private var byteoffset:Number = 0;
        private var connection:NetConnection;
        private var timeoffset:Number = 0;
        private var transformer:SoundTransform;
        private var loadinterval:Number;
        private var bwtimeout:Number;
        private var mp4:Boolean;
        private var startparam:String = "start";
        private var video:Video;

        public function HTTPModel(param1:Model) : void
        {
            super(param1);
            this.connection = new NetConnection();
            this.connection.connect(null);
            this.stream = new NetStream(this.connection);
            this.stream.checkPolicyFile = true;
            this.stream.addEventListener(NetStatusEvent.NET_STATUS, this.statusHandler);
            this.stream.addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
            this.stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.errorHandler);
            this.stream.bufferTime = model.config["bufferlength"];
            this.stream.client = new NetClient(this);
            this.transformer = new SoundTransform();
            this.video = new Video(320, 240);
            this.video.smoothing = model.config["smoothing"];
            this.video.attachNetStream(this.stream);
            addChild(this.video);
            return;
        }// end function

        private function getBandwidth(param1:Number) : void
        {
            var _loc_2:* = this.stream.bytesLoaded;
            var _loc_3:* = Math.round((_loc_2 - param1) * 4 / 1000);
            if (_loc_2 < this.stream.bytesTotal)
            {
                if (_loc_3 > 0)
                {
                    model.config["bandwidth"] = _loc_3;
                }
                if (this.bwswitch)
                {
                    this.bwswitch = false;
                    if (item["levels"] && this.getLevel() != model.config["level"])
                    {
                        this.byteoffset = -1;
                        this.seek(position);
                        return;
                    }
                }
                this.bwtimeout = setTimeout(this.getBandwidth, 2000, _loc_2);
            }
            return;
        }// end function

        override public function resize() : void
        {
            super.resize();
            if (item["levels"] && this.getLevel() != model.config["level"])
            {
                this.byteoffset = this.getOffset(position);
                var _loc_1:* = this.getOffset(position, true);
                position = this.getOffset(position, true);
                this.timeoffset = _loc_1;
                this.load(item);
            }
            return;
        }// end function

        private function loadHandler() : void
        {
            var _loc_1:* = this.stream.bytesLoaded;
            var _loc_2:* = this.stream.bytesTotal;
            var _loc_3:* = this.timeoffset / (item["duration"] + 0.001);
            var _loc_4:* = Math.round(_loc_2 * _loc_3 / (1 - _loc_3));
            _loc_2 = _loc_2 + _loc_4;
            model.sendEvent(ModelEvent.LOADED, {loaded:_loc_1, total:_loc_2, offset:_loc_4});
            if (_loc_1 + _loc_4 >= _loc_2 && _loc_1 > 0)
            {
                clearInterval(this.loadinterval);
            }
            if (_loc_1 > 0 && !this.bwcheck)
            {
                this.bwcheck = true;
                this.bwtimeout = setTimeout(this.getBandwidth, 2000, _loc_1);
            }
            return;
        }// end function

        private function getURL() : String
        {
            var _loc_1:* = item["file"];
            var _loc_2:* = this.byteoffset;
            if (model.config["http.startparam"])
            {
                this.startparam = model.config["http.startparam"];
            }
            if (item["streamer"])
            {
                if (item["streamer"].indexOf("/") > -1)
                {
                    _loc_1 = this.getURLConcat(item["streamer"], "file", item["file"]);
                }
                else
                {
                    this.startparam = item["streamer"];
                }
            }
            if (this.mp4)
            {
                _loc_2 = this.timeoffset;
            }
            else if (this.startparam == "starttime")
            {
                this.startparam = "start";
            }
            if (!this.mp4 || _loc_2 > 0)
            {
                _loc_1 = this.getURLConcat(_loc_1, this.startparam, _loc_2);
            }
            if (model.config["token"])
            {
                _loc_1 = this.getURLConcat(_loc_1, "token", model.config["token"]);
            }
            return _loc_1;
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

        private function getOffset(param1:Number, param2:Boolean = false) : Number
        {
            if (!this.keyframes)
            {
                return 0;
            }
            var _loc_3:Number = 0;
            while (_loc_3 < (this.keyframes.times.length - 1))
            {
                
                if (this.keyframes.times[_loc_3] <= param1 && this.keyframes.times[(_loc_3 + 1)] >= param1)
                {
                    break;
                }
                _loc_3 = _loc_3 + 1;
            }
            if (param2 == true)
            {
                return this.keyframes.times[_loc_3];
            }
            return this.keyframes.filepositions[_loc_3];
        }// end function

        private function positionInterval() : void
        {
            var _loc_1:* = Math.round(this.stream.time * 10) / 10;
            if (this.mp4)
            {
                _loc_1 = _loc_1 + this.timeoffset;
            }
            var _loc_2:* = this.stream.bufferLength / this.stream.bufferTime;
            if (_loc_2 < 0.5 && _loc_1 < item["duration"] - 5 && model.config["state"] != ModelStates.BUFFERING)
            {
                model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.BUFFERING});
            }
            else if (_loc_2 > 1 && model.config["state"] != ModelStates.PLAYING)
            {
                model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PLAYING});
            }
            if (_loc_1 < item["duration"] + 10)
            {
                if (_loc_1 != position)
                {
                    model.sendEvent(ModelEvent.TIME, {position:_loc_1, duration:item["duration"]});
                    position = _loc_1;
                }
            }
            else if (item["duration"] > 0)
            {
                this.stream.pause();
                clearInterval(this.interval);
                model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.COMPLETED});
            }
            return;
        }// end function

        override public function stop() : void
        {
            if (this.stream.bytesLoaded < this.stream.bytesTotal)
            {
                this.stream.close();
            }
            else
            {
                this.stream.pause();
            }
            clearInterval(this.interval);
            clearInterval(this.loadinterval);
            var _loc_1:int = 0;
            position = 0;
            var _loc_1:* = _loc_1;
            this.timeoffset = _loc_1;
            this.byteoffset = _loc_1;
            this.keyframes = undefined;
            this.meta = false;
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.IDLE});
            return;
        }// end function

        override public function volume(param1:Number) : void
        {
            this.transformer.volume = param1 / 100;
            this.stream.soundTransform = this.transformer;
            return;
        }// end function

        public function onClientData(param1:Object) : void
        {
            if (param1.width)
            {
                this.video.width = param1.width;
                this.video.height = param1.height;
                super.resize();
            }
            if (!item["duration"] && param1.duration)
            {
                item["duration"] = param1.duration;
            }
            if (param1["type"] == "metadata" && !this.meta)
            {
                this.meta = true;
                if (param1.seekpoints)
                {
                    this.mp4 = true;
                    this.keyframes = this.convertSeekpoints(param1.seekpoints);
                }
                else
                {
                    this.mp4 = false;
                    this.keyframes = param1.keyframes;
                }
                if (item["start"] > 0)
                {
                    this.seek(item["start"]);
                }
            }
            model.sendEvent(ModelEvent.META, param1);
            return;
        }// end function

        private function errorHandler(event:ErrorEvent) : void
        {
            this.stop();
            model.sendEvent(ModelEvent.ERROR, {message:event.text});
            return;
        }// end function

        private function getURLConcat(param1:String, param2:String, param3) : String
        {
            if (param1.indexOf("?") > -1)
            {
                return param1 + "&" + param2 + "=" + param3;
            }
            return param1 + "?" + param2 + "=" + param3;
        }// end function

        private function convertSeekpoints(param1:Object) : Object
        {
            var _loc_3:String = null;
            var _loc_2:* = new Object();
            _loc_2.times = new Array();
            _loc_2.filepositions = new Array();
            for (_loc_3 in param1)
            {
                
                _loc_2.times[_loc_3] = Number(param1[_loc_3]["time"]);
                _loc_2.filepositions[_loc_3] = Number(param1[_loc_3]["offset"]);
            }
            return _loc_2;
        }// end function

        override public function pause() : void
        {
            this.stream.pause();
            clearInterval(this.interval);
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PAUSED});
            return;
        }// end function

        override public function play() : void
        {
            this.stream.resume();
            this.interval = setInterval(this.positionInterval, 100);
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PLAYING});
            return;
        }// end function

        override public function load(param1:Object) : void
        {
            item = param1;
            position = this.timeoffset;
            this.bwcheck = false;
            if (item["levels"])
            {
                model.config["level"] = this.getLevel();
                item["file"] = item["levels"][model.config["level"]].url;
            }
            this.stream.play(this.getURL());
            clearInterval(this.interval);
            this.interval = setInterval(this.positionInterval, 100);
            clearInterval(this.loadinterval);
            this.loadinterval = setInterval(this.loadHandler, 200);
            clearTimeout(this.bwtimeout);
            if (model.config["mute"] == true)
            {
                this.volume(0);
            }
            else
            {
                this.volume(model.config["volume"]);
            }
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.BUFFERING});
            return;
        }// end function

        override public function seek(param1:Number) : void
        {
            var _loc_2:* = this.getOffset(param1);
            clearInterval(this.interval);
            if (_loc_2 < this.byteoffset || _loc_2 >= this.byteoffset + this.stream.bytesLoaded)
            {
                var _loc_3:* = this.getOffset(param1, true);
                position = this.getOffset(param1, true);
                this.timeoffset = _loc_3;
                this.byteoffset = _loc_2;
                this.load(item);
            }
            else
            {
                if (model.config["state"] == ModelStates.PAUSED)
                {
                    this.stream.resume();
                }
                position = param1;
                if (this.mp4)
                {
                    this.stream.seek(this.getOffset(position - this.timeoffset, true));
                }
                else
                {
                    this.stream.seek(this.getOffset(position, true));
                }
                this.play();
            }
            return;
        }// end function

        private function statusHandler(event:NetStatusEvent) : void
        {
            switch(event.info.code)
            {
                case "NetStream.Play.Stop":
                {
                    if (model.config["state"] != ModelStates.COMPLETED && model.config["state"] != ModelStates.BUFFERING)
                    {
                        clearInterval(this.interval);
                        model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.COMPLETED});
                    }
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                {
                    this.stop();
                    model.sendEvent(ModelEvent.ERROR, {message:"Video not found: " + item["file"]});
                    break;
                }
                default:
                {
                    break;
                }
            }
            model.sendEvent(ModelEvent.META, {info:event.info.code});
            return;
        }// end function

    }
}
