package org.lala.models
{
    import com.jeroenwijering.events.*;
    import com.jeroenwijering.models.*;
    import com.jeroenwijering.player.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;

    public class BOKECCModel extends AbstractModel
    {
        protected var bi:int = -1;
        protected var state:String;
        protected var totle:int;
        protected var vol:Number;
        protected var nss:Array;
        protected var infoLoader:URLLoader;
        protected var ifs:Array;
        protected var pi:int = -1;
        protected var video:Video;
        protected var ofs:Array;

        public function BOKECCModel(param1:Model) : void
        {
            this.nss = [];
            this.ofs = [];
            this.ifs = [];
            super(param1);
            this.video = new Video();
            this.video.smoothing = model.config["smoothing"];
            this.vol = model.config["mute"] == true ? (0) : (model.config["volume"] / 100);
            addChild(this.video);
            return;
        }// end function

        protected function playingHandler(event:NSEvent) : void
        {
            var _loc_2:* = Math.round(this.getns(this.pi).ns.time * 10) / 10;
            var _loc_3:* = this.getns(this.pi).ns.bufferLength / this.getns(this.pi).ns.bufferTime;
            if (_loc_3 < 0.5 && _loc_2 < this.ifs[this.pi].length - 10 && model.config["state"] != ModelStates.BUFFERING)
            {
                model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.BUFFERING});
            }
            else if (_loc_3 > 1 && model.config["state"] != ModelStates.PLAYING)
            {
                model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PLAYING});
            }
            if (this.pi == 0)
            {
                position = uint(event.info) / 1000;
                model.sendEvent(ModelEvent.TIME, {position:uint(event.info) / 1000, duration:this.totle / 1000});
            }
            else
            {
                position = uint(parseInt(this.ofs[(this.pi - 1)]) + uint(event.info)) / 1000;
                model.sendEvent(ModelEvent.TIME, {position:uint(parseInt(this.ofs[(this.pi - 1)]) + uint(event.info)) / 1000, duration:this.totle / 1000});
            }
            return;
        }// end function

        protected function changeNS() : void
        {
            if (this.pi >= 0)
            {
                if (!this.nss[this.pi])
                {
                    return;
                }
                this.getns(this.pi).stopV();
            }
            if (this.nss[(this.pi + 1)])
            {
                trace("change ns : " + (this.pi + 1));
                var _loc_1:String = this;
                _loc_1.pi = this.pi + 1;
                this.getns(++this.pi).playV();
                this.video.clear();
                this.video.attachNetStream(this.getns(this.pi).ns);
                this.getns(this.pi).stopV();
                this.getns(this.pi).playV();
            }
            return;
        }// end function

        override public function pause() : void
        {
            if (this.state == "pause")
            {
                return;
            }
            if (this.state == "play")
            {
                this.getns(this.pi).pauseV();
                this.state = "pause";
                model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PAUSED});
            }
            return;
        }// end function

        protected function bufferingHandler(event:NSEvent) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            if (this.bi == 0)
            {
                _loc_2 = int(this.ofs[this.bi]) / this.totle;
                _loc_3 = Number(event.info) * _loc_2;
                model.sendEvent(ModelEvent.LOADED, {loaded:_loc_3, total:1});
            }
            else
            {
                _loc_4 = int(this.ofs[(this.bi - 1)]) / this.totle;
                _loc_2 = int(this.ofs[this.bi]) / this.totle;
                _loc_3 = _loc_4 + Number(event.info) * (_loc_2 - _loc_4);
                model.sendEvent(ModelEvent.LOADED, {loaded:_loc_3, total:1});
            }
            return;
        }// end function

        override public function stop() : void
        {
            var _loc_1:int = 0;
            if (this.state == "pause" || this.state == "ready")
            {
                return;
            }
            if (this.state == "play")
            {
                _loc_1 = 0;
                while (_loc_1 < this.nss.length)
                {
                    
                    this.getns(_loc_1).stopV();
                    _loc_1++;
                }
                this.video.clear();
                this.pi = -1;
                this.changeNS();
                this.pause();
                trace("STOP pause() : ");
                return;
            }
            trace("STOP out ");
            return;
        }// end function

        protected function getPIByTime(param1:Number) : uint
        {
            return 0;
        }// end function

        protected function seekInPart(param1:Number, param2:uint) : void
        {
            var _loc_3:Number = NaN;
            if (param2 == 0)
            {
                _loc_3 = param1;
            }
            else
            {
                _loc_3 = param1 - this.ofs[(param2 - 1)];
            }
            this.pause();
            this.getns(this.pi).seekV(_loc_3);
            this.play();
            return;
        }// end function

        protected function uidLoadHandler(event:Event) : void
        {
            this.infoLoader.removeEventListener(Event.COMPLETE, this.uidLoadHandler);
            var _loc_2:* = this.infoLoader.data as String;
            var _loc_3:* = _loc_2.match(/_([^_]{4,})_/i);
            if (_loc_3)
            {
                item["uid"] = _loc_3[1];
                this.infoLoader.load(new URLRequest(this.getFlvUrl(item["vid"], item["uid"])));
                this.infoLoader.addEventListener(Event.COMPLETE, this.flvLoaderHandler);
            }
            return;
        }// end function

        override public function volume(param1:Number) : void
        {
            this.vol = param1 / 100;
            var _loc_2:uint = 0;
            while (_loc_2 < this.nss.length)
            {
                
                this.getns(_loc_2).volume = this.vol;
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        protected function metadataHandler(event:NSEvent) : void
        {
            if (event.info["width"])
            {
                this.video.width = event.info["width"];
                this.video.height = event.info["height"];
            }
            if (event.info.duration)
            {
                item["duration"] = parseFloat(event.info.duration);
                this.totle = item["duration"] * 1000;
                this.ifs[0].length = this.totle;
                this.ofs[0] = this.totle;
                trace("evt.info.duration : " + item["duration"]);
            }
            super.resize();
            model.sendEvent(ModelEvent.META, event.info);
            this.getns(0).removeEventListener(NSEvent.META_DATA, this.metadataHandler);
            return;
        }// end function

        protected function createBuffer() : void
        {
            var _loc_1:NS = null;
            var _loc_2:String = this;
            _loc_2.bi = this.bi + 1;
            if (this.ifs[++this.bi])
            {
                trace("create buffer : " + this.bi);
                _loc_1 = new NS();
                _loc_1.addEventListener(NSEvent.PLAYING, this.playingHandler);
                _loc_1.addEventListener(NSEvent.BUFFERING, this.bufferingHandler);
                _loc_1.addEventListener(NSEvent.CHECK_FULL, this.checkfullHandler);
                _loc_1.addEventListener(NSEvent.STOP, this.stopHandler);
                if (this.bi == 0)
                {
                    _loc_1.addEventListener(NSEvent.META_DATA, this.metadataHandler);
                }
                _loc_1.id = this.ifs[this.bi].id;
                _loc_1.volume = this.vol;
                _loc_1.loadV(this.ifs[this.bi].url);
                this.nss.push(_loc_1);
                return;
            }
            trace("buffer all full");
            return;
        }// end function

        protected function flvLoaderHandler(event:Event) : void
        {
            this.infoLoader.removeEventListener(Event.COMPLETE, this.flvLoaderHandler);
            var _loc_2:* = this.infoLoader.data as String;
            var _loc_3:* = _loc_2.match(/flvPath="([^"]+)"/i);
            if (_loc_3)
            {
                item["file"] = _loc_3[1];
                this.totle = 0;
                this.ifs = [{url:item["file"], length:0}];
                this.ofs = [0];
                this.nss = [];
                this.pi = -1;
                this.bi = -1;
                item["duration"] = this.totle / 1000;
                model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PAUSED});
                this.state = "ready";
                this.play();
            }
            else
            {
                model.sendEvent(ModelEvent.ERROR, {message:"bokeccÊÓÆµÔØÈëÊ§°Ü-_-!"});
            }
            return;
        }// end function

        protected function stopHandler(event:NSEvent) : void
        {
            if (this.pi != (this.ifs.length - 1))
            {
                this.changeNS();
                return;
            }
            var _loc_2:int = 0;
            while (_loc_2 < this.nss.length)
            {
                
                this.getns(_loc_2).stopV();
                _loc_2++;
            }
            this.video.clear();
            this.pi = -1;
            this.changeNS();
            this.getns(this.pi).pauseV();
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.COMPLETED});
            return;
        }// end function

        protected function getns(param1:int) : NS
        {
            return NS(this.nss[param1]);
        }// end function

        override public function load(param1:Object) : void
        {
            super.load(param1);
            this.infoLoader = new URLLoader();
            this.infoLoader.addEventListener(Event.COMPLETE, this.uidLoadHandler);
            this.infoLoader.load(new URLRequest(this.getUidUrl(param1["vid"])));
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.BUFFERING});
            return;
        }// end function

        override public function play() : void
        {
            if (this.state == "play")
            {
                return;
            }
            if (this.state == "ready")
            {
                this.createBuffer();
                this.changeNS();
                this.state = "play";
                model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PLAYING});
            }
            if (this.state == "pause")
            {
                this.getns(this.pi).playV();
                this.state = "play";
                model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PLAYING});
            }
            return;
        }// end function

        protected function getUidUrl(param1:String) : String
        {
            return "http://union.bokecc.com/servlet/getPlayerSkin?videoID=" + param1 + "&userID=0";
        }// end function

        protected function getFlvUrl(param1:String, param2:String) : String
        {
            return "http://union.bokecc.com/servlet/GetVideoStatus?videoID=" + param1 + "&userID=" + param2;
        }// end function

        protected function checkfullHandler(event:NSEvent) : void
        {
            this.getns(this.bi).removeEventListener(NSEvent.BUFFERING, this.bufferingHandler);
            this.getns(this.bi).removeEventListener(NSEvent.CHECK_FULL, this.checkfullHandler);
            this.createBuffer();
            return;
        }// end function

        override public function seek(param1:Number) : void
        {
            position = param1;
            param1 = param1 * 1000;
            if (this.state == "ready" || this.state == "pause")
            {
                this.play();
                this.seek(position);
                this.pause();
                return;
            }
            this.seekInPart(param1, 0);
            return;
        }// end function

    }
}
