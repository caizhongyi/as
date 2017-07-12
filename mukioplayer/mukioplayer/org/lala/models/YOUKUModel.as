package org.lala.models
{
    import com.adobe.serialization.json.*;
    import com.jeroenwijering.events.*;
    import com.jeroenwijering.player.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class YOUKUModel extends SINAModel
    {
        protected var infoLoader:URLLoader;
        private var youkuTimer:uint;
        private var youkuFlag:Object;
        private var type:String = "flv";

        public function YOUKUModel(param1:Model) : void
        {
            this.youkuFlag = {0:true};
            super(param1);
            return;
        }// end function

        override public function load(param1:Object) : void
        {
            item = param1;
            position = 0;
            this.infoLoader = new URLLoader();
            this.infoLoader.addEventListener(Event.COMPLETE, this.jsonLoadHandler);
            this.infoLoader.load(new URLRequest(this.getJSONUrl(param1["vid"])));
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.BUFFERING});
            return;
        }// end function

        override protected function seekInPart(param1:Number, param2:uint) : void
        {
            super.seekInPart(param1, param2);
            this.youkuTimer = undefined;
            return;
        }// end function

        protected function getJSONUrl(param1:String) : String
        {
            return "http://v.youku.com/player/getPlayList/VideoIDS/" + param1 + "/";
        }// end function

        protected function jsonLoadHandler(event:Event) : void
        {
            var _loc_4:String = null;
            var _loc_5:YKParser = null;
            var _loc_6:int = 0;
            var _loc_7:uint = 0;
            this.infoLoader.removeEventListener(Event.COMPLETE, this.jsonLoadHandler);
            var _loc_2:* = this.infoLoader.data as String;
            var _loc_3:* = JSON.decode(_loc_2);
            if (_loc_3)
            {
                _loc_3 = _loc_3.data[0];
                for (_loc_4 in _loc_3.streamtypes)
                {
                    
                    if (String(_loc_3.streamtypes[_loc_4]).toLowerCase() == "mp4")
                    {
                        this.type = "mp4";
                    }
                }
                _loc_5 = new YKParser(_loc_3, this.type);
                totle = parseFloat(_loc_3["seconds"]) * 1000;
                ifs = [];
                _loc_6 = 0;
                while (_loc_6 < _loc_3["segs"][this.type].length)
                {
                    
                    ifs.push({url:_loc_5.getUrl(_loc_6), length:parseInt(_loc_3["segs"][this.type][_loc_6].seconds) * 1000, id:(_loc_6 + 1)});
                    _loc_6++;
                }
                if (!totle)
                {
                    model.sendEvent(ModelEvent.ERROR, {message:"视频出错了!"});
                    return;
                }
                nss = [];
                ofs = [];
                _loc_7 = 0;
                _loc_6 = 0;
                while (_loc_6 < ifs.length)
                {
                    
                    var _loc_8:* = _loc_7 + ifs[_loc_6].length;
                    _loc_7 = _loc_7 + ifs[_loc_6].length;
                    ofs[_loc_6] = _loc_8;
                    _loc_6++;
                }
                pi = -1;
                bi = -1;
                item["duration"] = totle / 1000;
                model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PAUSED});
                state = "ready";
                play();
            }
            else
            {
                model.sendEvent(ModelEvent.ERROR, {message:"播放地址出错了!"});
            }
            return;
        }// end function

        override public function seek(param1:Number) : void
        {
            position = param1;
            param1 = param1 * 1000;
            if (state == "ready" || state == "pause")
            {
                play();
                this.seek(position);
                pause();
                return;
            }
            var _loc_2:* = getPIByTime(param1);
            if (_loc_2 == pi)
            {
                this.seekInPart(param1, _loc_2);
                return;
            }
            if (_loc_2 >= nss.length)
            {
                return;
            }
            var _loc_3:int = 0;
            while (_loc_3 < nss.length)
            {
                
                getns(_loc_3).stopV();
                _loc_3++;
            }
            video.clear();
            pi = _loc_2;
            getns(pi).playV();
            video.attachNetStream(getns(pi).ns);
            if (!this.youkuFlag[String(pi)])
            {
                this.youkuFlag[String(pi)] = true;
                if (this.youkuTimer)
                {
                    clearTimeout(this.youkuTimer);
                }
                this.youkuTimer = setTimeout(this.seekInPart, 500, param1, pi);
            }
            else
            {
                this.seekInPart(param1, pi);
            }
            return;
        }// end function

    }
}
