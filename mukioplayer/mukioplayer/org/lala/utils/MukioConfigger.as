package org.lala.utils
{
    import flash.events.*;
    import flash.filters.*;
    import flash.net.*;

    public class MukioConfigger extends Object
    {
        public static var CMTMAXHEIGHT:int = 768;
        public static var QID2URI:String = "http://vsrc.store.qq.com/{$id}.flv?channel=vhot2&sdtfrom%3dv2&r%3d931&rfc=v0";
        public static var CMTMAXWIDTH:int = 2048;
        public static var SERVGATEWAY:String = "";
        public static var LOADMETHOD:String = "get";
        public static var CMTMAX:int = 120;
        public static var CMTSTARTPOS:int = 30;
        public static var _inst:MukioConfigger;
        public static var CMTFILTER:Array = [new GlowFilter(0, 0.7, 3, 3)];
        public static var CMTMAXSTYLED:int = 80;
        public static var CMTBOLD:Boolean = true;
        public static var SERVSEND:String = "/newflvplayer/cnmd.aspx";
        public static var CMTVCEF:Number = 150;
        public static var CMTFONT:String = "ºÚÌå";
        public static var SERVLOAD:String = "/newflvplayer/xmldata/{$id}/comment_on.xml?";
        public static var CMTFILTERBLACK:Array = [new GlowFilter(16777215, 1, 3, 3)];

        public function MukioConfigger()
        {
            if (!MukioConfigger._inst)
            {
                MukioConfigger._inst = this;
            }
            else
            {
                throw new Error("MukioConfigger instance exists!");
            }
            return;
        }// end function

        private function completeHandler(event:Event) : void
        {
            trace("config loaded.");
            this.parseParams(XML(event.target.data));
            return;
        }// end function

        private function errorHandler(event:IOErrorEvent) : void
        {
            trace("config load error.");
            return;
        }// end function

        private function parseBoolean(param1:String) : Boolean
        {
            param1 = param1.toLowerCase();
            if (param1 == "true")
            {
                return true;
            }
            return false;
        }// end function

        public function load(param1:String, param2:String = "conf.xml") : void
        {
            var root:* = param1;
            var path:* = param2;
            path = root.replace(/[^\/]+.swf/igm, path);
            trace("path : " + path);
            var loader:* = new URLLoader();
            loader.addEventListener(Event.COMPLETE, this.completeHandler);
            loader.addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
            try
            {
                loader.load(new URLRequest(path));
            }
            catch (e:Error)
            {
                trace(e);
            }
            return;
        }// end function

        private function parseParams(param1:XML) : void
        {
            trace("params parsed");
            if (param1.style.fontfamily)
            {
                CMTFONT = String(param1.style.fontfamily);
            }
            if (param1.style.bold)
            {
                CMTBOLD = this.parseBoolean(param1.style.bold);
            }
            if (param1.style.effect)
            {
                CMTFILTER = this.parseFilter(param1.style.effect);
            }
            if (param1.style.beffect)
            {
                CMTFILTERBLACK = this.parseFilter(param1.style.beffect);
            }
            if (param1.performance.startpos)
            {
                CMTSTARTPOS = int(param1.performance.startpos);
            }
            if (param1.performance.vc)
            {
                CMTVCEF = Number(param1.performance.vc);
            }
            if (param1.performance.maxwidth)
            {
                CMTMAXWIDTH = int(param1.performance.maxwidth);
            }
            if (param1.performance.maxheight)
            {
                CMTMAXHEIGHT = int(param1.performance.maxheight);
            }
            if (param1.performance.maxonstage)
            {
                CMTMAX = int(param1.performance.maxonstage);
            }
            if (param1.performance.maxwitheffect)
            {
                CMTMAXSTYLED = int(param1.performance.maxwitheffect);
            }
            if (param1.server.load)
            {
                SERVLOAD = String(param1.server.load);
            }
            if (param1.server.send)
            {
                SERVSEND = String(param1.server.send);
            }
            if (param1.server.gateway)
            {
                SERVGATEWAY = String(param1.server.gateway);
            }
            if (param1.server.loadmethod)
            {
                LOADMETHOD = String(param1.server.loadmethod);
            }
            if (param1.video)
            {
                if (param1.video.qid2uri.length)
                {
                    QID2URI = String(param1.video.qid2uri);
                }
            }
            return;
        }// end function

        private function parseFilter(param1:XMLList) : Array
        {
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:int = 0;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:int = 0;
            var _loc_11:Boolean = false;
            var _loc_12:Boolean = false;
            var _loc_13:Boolean = false;
            var _loc_2:* = param1.@name;
            if (_loc_2 == "DropShadowFilter")
            {
                _loc_3 = parseFloat(param1.@distance);
                _loc_4 = parseFloat(param1.@angle);
                _loc_5 = parseInt(param1.@color);
                _loc_6 = parseFloat(param1.@alpha);
                _loc_7 = parseFloat(param1.@blurX);
                _loc_8 = parseFloat(param1.@blurY);
                _loc_9 = parseFloat(param1.@strength);
                _loc_10 = parseInt(param1.@quality);
                _loc_11 = this.parseBoolean(param1.@inner);
                _loc_12 = this.parseBoolean(param1.@knockout);
                _loc_13 = this.parseBoolean(param1.@hideObject);
                return [new DropShadowFilter(_loc_3, _loc_4, _loc_5, _loc_6, _loc_7, _loc_8, _loc_9, _loc_10, _loc_11, _loc_12, _loc_13)];
            }
            if (_loc_2 == "GlowFilter")
            {
                _loc_5 = parseInt(param1.@color);
                _loc_6 = parseFloat(param1.@alpha);
                _loc_7 = parseFloat(param1.@blurX);
                _loc_8 = parseFloat(param1.@blurY);
                _loc_9 = parseFloat(param1.@strength);
                _loc_10 = parseInt(param1.@quality);
                _loc_11 = this.parseBoolean(param1.@inner);
                _loc_12 = this.parseBoolean(param1.@knockout);
                return [new GlowFilter(_loc_5, _loc_6, _loc_7, _loc_8, _loc_9, _loc_10, _loc_11, _loc_12)];
            }
            return [new GlowFilter(0, 0.7, 3, 3)];
        }// end function

        public static function getInst() : MukioConfigger
        {
            if (!MukioConfigger._inst)
            {
                new MukioConfigger;
            }
            return MukioConfigger._inst;
        }// end function

    }
}
