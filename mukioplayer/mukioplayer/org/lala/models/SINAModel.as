package org.lala.models
{
    import com.jeroenwijering.events.*;
    import com.jeroenwijering.models.*;
    import com.jeroenwijering.player.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;

    public class SINAModel extends AbstractModel
    {
        protected var ofs:Array;
        protected var bi:int = -1;
        protected var state:String;
        protected var totle:int;
        protected var vol:Number;
        protected var nss:Array;
        protected var ifs:Array;
        protected var pi:int = -1;
        protected var video:Video;

        public function SINAModel(param1:Model) : void
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

        protected function getXMLUrl(param1:String) : String
        {
            return "http://v.iask.com/v_play.php?vid=" + param1;
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
            super.resize();
            model.sendEvent(ModelEvent.META, event.info);
            this.getns(0).removeEventListener(NSEvent.META_DATA, this.metadataHandler);
            return;
        }// end function

        protected function getPIByTime(param1:Number) : uint
        {
            var _loc_2:uint = 0;
            var _loc_3:Number = -1;
            while (_loc_2 < this.nss.length)
            {
                
                if (param1 > _loc_3 && param1 <= this.ofs[_loc_2])
                {
                    break;
                }
                _loc_3 = this.ofs[_loc_2++];
            }
            return _loc_2;
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
            var _loc_2:* = new URLLoader();
            _loc_2.addEventListener(Event.COMPLETE, this.xmlLoadHandler);
            _loc_2.load(new URLRequest(this.getXMLUrl(param1["vid"])));
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

        protected function checkfullHandler(event:NSEvent) : void
        {
            this.getns(this.bi).removeEventListener(NSEvent.BUFFERING, this.bufferingHandler);
            this.getns(this.bi).removeEventListener(NSEvent.CHECK_FULL, this.checkfullHandler);
            this.createBuffer();
            return;
        }// end function

        protected function xmlLoadHandler(event:Event) : void
        {
            var itm:XML;
            var data:XML;
            var evt:* = event;
            trace("item[\'vid\'] :>" + item["vid"] + "<");
            if (item["vid"] == "-1")
            {
                model.sendEvent(ModelEvent.ERROR, {message:"使用方法: 见程序目录readme.txt"});
                return;
            }
            try
            {
                data = XML(evt.target.data);
            }
            catch (e:Error)
            {
                trace("load vid xml error,not a xml file" + evt.target.data);
                model.sendEvent(ModelEvent.ERROR, {message:"播放地址出错了!"});
                return;
            }
            this.totle = data.timelength;
            trace("data.timelength : " + data.timelength);
            this.ifs = [];
            var _loc_3:int = 0;
            var _loc_4:* = data.descendants("durl");
            while (_loc_4 in _loc_3)
            {
                
                itm = _loc_4[_loc_3];
                this.ifs.push({url:itm.url, length:parseInt(itm.length), id:itm.order});
            }
            if (!this.totle)
            {
                model.sendEvent(ModelEvent.ERROR, {message:"视频出错了!"});
                return;
            }
            this.nss = [];
            this.ofs = [];
            var co:uint;
            var i:uint;
            while (i < this.ifs.length)
            {
                
                var _loc_3:* = co + this.ifs[i].length;
                co = co + this.ifs[i].length;
                this.ofs[i] = _loc_3;
                i = (i + 1);
            }
            this.pi = -1;
            this.bi = -1;
            item["duration"] = this.totle / 1000;
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PAUSED});
            this.state = "ready";
            this.play();
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
            var _loc_2:* = this.getPIByTime(param1);
            if (_loc_2 == this.pi)
            {
                this.seekInPart(param1, _loc_2);
                return;
            }
            if (_loc_2 >= this.nss.length)
            {
                trace("si >= nss.length : ");
                return;
            }
            var _loc_3:int = 0;
            while (_loc_3 < this.nss.length)
            {
                
                this.getns(_loc_3).stopV();
                _loc_3++;
            }
            this.video.clear();
            this.pi = _loc_2;
            this.video.attachNetStream(this.getns(this.pi).ns);
            this.seekInPart(param1, this.pi);
            return;
        }// end function

    }
}
