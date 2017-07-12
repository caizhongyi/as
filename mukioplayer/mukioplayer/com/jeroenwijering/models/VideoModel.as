package com.jeroenwijering.models
{
    import com.jeroenwijering.events.*;
    import com.jeroenwijering.player.*;
    import com.jeroenwijering.utils.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class VideoModel extends AbstractModel
    {
        private var stream:NetStream;
        private var loading:Number;
        private var interval:Number;
        private var bwswitch:Boolean = true;
        private var bwcheck:Boolean;
        private var transformer:SoundTransform;
        private var connection:NetConnection;
        private var video:Video;

        public function VideoModel(param1:Model) : void
        {
            super(param1);
            this.connection = new NetConnection();
            this.connection.connect(null);
            this.stream = new NetStream(this.connection);
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
                        model.config["level"] = this.getLevel();
                        item["file"] = item["levels"][model.config["level"]].url;
                        this.load(item);
                        return;
                    }
                }
                setTimeout(this.getBandwidth, 2000, _loc_2);
            }
            return;
        }// end function

        private function loadHandler() : void
        {
            var _loc_1:* = this.stream.bytesLoaded;
            var _loc_2:* = this.stream.bytesTotal;
            model.sendEvent(ModelEvent.LOADED, {loaded:_loc_1, total:_loc_2});
            if (_loc_1 && _loc_1 == _loc_2)
            {
                clearInterval(this.loading);
            }
            if (_loc_1 > 0 && !this.bwcheck)
            {
                this.bwcheck = true;
                setTimeout(this.getBandwidth, 2000, _loc_1);
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

        private function statusHandler(event:NetStatusEvent) : void
        {
            switch(event.info.code)
            {
                case "NetStream.Play.Stop":
                {
                    if (position > 1)
                    {
                        clearInterval(this.interval);
                        model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.COMPLETED});
                    }
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                {
                    this.stop();
                    model.sendEvent(ModelEvent.ERROR, {message:"Video not found or access denied: " + item["file"]});
                    break;
                }
                default:
                {
                    break;
                }
            }
            model.sendEvent(ModelEvent.META, {status:event.info.code});
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
            clearInterval(this.loading);
            clearInterval(this.interval);
            position = 0;
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.IDLE});
            return;
        }// end function

        public function onClientData(param1:Object) : void
        {
            if (param1.width)
            {
                this.video.width = param1.width;
                this.video.height = param1.height;
                resize();
            }
            if (param1.duration && !item["duration"])
            {
                item["duration"] = param1.duration;
            }
            model.sendEvent(ModelEvent.META, param1);
            return;
        }// end function

        private function positionInterval() : void
        {
            var _loc_1:* = Math.round(this.stream.time * 10) / 10;
            var _loc_2:* = this.stream.bufferLength / this.stream.bufferTime;
            if (_loc_2 < 0.5 && position < item["duration"] - 5 && model.config["state"] != ModelStates.BUFFERING)
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
                    position = _loc_1;
                    model.sendEvent(ModelEvent.TIME, {position:_loc_1, duration:item["duration"]});
                }
            }
            else if (item["duration"])
            {
                this.stream.pause();
                clearInterval(this.interval);
                model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.COMPLETED});
            }
            return;
        }// end function

        override public function volume(param1:Number) : void
        {
            this.transformer.volume = param1 / 100;
            this.stream.soundTransform = this.transformer;
            return;
        }// end function

        private function errorHandler(event:ErrorEvent) : void
        {
            this.stop();
            model.sendEvent(ModelEvent.ERROR, {message:event.text});
            return;
        }// end function

        override public function load(param1:Object) : void
        {
            item = param1;
            position = 0;
            this.bwcheck = false;
            if (item["levels"])
            {
                model.config["level"] = this.getLevel();
                item["file"] = item["levels"][model.config["level"]].url;
            }
            this.stream.checkPolicyFile = true;
            this.stream.play(item["file"]);
            clearInterval(this.interval);
            this.interval = setInterval(this.positionInterval, 100);
            clearInterval(this.loading);
            this.loading = setInterval(this.loadHandler, 200);
            if (model.config["mute"] == true)
            {
                this.volume(0);
            }
            else
            {
                this.volume(model.config["volume"]);
            }
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.BUFFERING});
            resize();
            return;
        }// end function

        override public function play() : void
        {
            this.stream.resume();
            this.interval = setInterval(this.positionInterval, 100);
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PLAYING});
            return;
        }// end function

        override public function pause() : void
        {
            this.stream.pause();
            clearInterval(this.interval);
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PAUSED});
            return;
        }// end function

        override public function seek(param1:Number) : void
        {
            if (this.stream && param1 < this.stream.bytesLoaded / this.stream.bytesTotal * item["duration"])
            {
                position = param1;
                clearInterval(this.interval);
                this.stream.seek(position);
                this.play();
            }
            return;
        }// end function

    }
}
