package org.lala.models
{
    import com.jeroenwijering.events.*;
    import com.jeroenwijering.player.*;
    import flash.events.*;
    import flash.net.*;

    public class SIXROOMModel extends BOKECCModel
    {

        public function SIXROOMModel(param1:Model) : void
        {
            super(param1);
            return;
        }// end function

        protected function flvXMLLoaderHandler(event:Event) : void
        {
            var data:XML;
            var flist:XMLList;
            var itm:XML;
            var evt:* = event;
            infoLoader.removeEventListener(Event.COMPLETE, this.flvXMLLoaderHandler);
            try
            {
                data = XML(infoLoader.data);
            }
            catch (e:Error)
            {
                model.sendEvent(ModelEvent.ERROR, {message:"播放地址出错了!"});
                return;
            }
            if (data)
            {
                flist = data.descendants("file");
                var _loc_3:int = 0;
                var _loc_4:* = flist;
                while (_loc_4 in _loc_3)
                {
                    
                    itm = _loc_4[_loc_3];
                    item["file"] = itm.toString();
                    break;
                }
                item["file"] = item["file"] + ("?" + this.getKeys());
                totle = 0;
                ifs = [{url:item["file"], length:0}];
                ofs = [0];
                nss = [];
                pi = -1;
                bi = -1;
                item["duration"] = totle / 1000;
                model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PAUSED});
                state = "ready";
                play();
            }
            else
            {
                model.sendEvent(ModelEvent.ERROR, {message:"6cn视频载入失败-_-!"});
            }
            return;
        }// end function

        protected function getKeys() : String
        {
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_1:* = new Date();
            var _loc_2:* = _loc_1.getTime() / 1000;
            _loc_2 = _loc_2 + 123456;
            var _loc_3:* = 1000000000 + Math.floor(Math.random() * 1000000000);
            var _loc_4:* = 1000000000 + Math.floor(Math.random() * 1000000000);
            var _loc_5:* = Math.random() * 100;
            if (Math.random() * 100 > 50)
            {
                _loc_6 = Math.abs(Math.floor(_loc_2 / 3) ^ _loc_3);
                _loc_7 = Math.abs(Math.floor(_loc_2 * 2 / 3) ^ _loc_4);
            }
            else
            {
                _loc_6 = Math.abs(Math.floor(_loc_2 * 2 / 3) ^ _loc_3);
                _loc_7 = Math.abs(Math.floor(_loc_2 / 3) ^ _loc_4);
            }
            return "key1=" + _loc_6.toString() + "&key2=" + _loc_7.toString() + "&key3=" + _loc_3.toString() + "&key4=" + _loc_4.toString();
        }// end function

        override public function load(param1:Object) : void
        {
            item = param1;
            position = 0;
            infoLoader = new URLLoader();
            infoLoader.addEventListener(Event.COMPLETE, this.xml1LoadHandler);
            infoLoader.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            var _loc_2:* = new URLRequest(this.getXML1Url(param1["vid"]));
            _loc_2.method = URLRequestMethod.POST;
            _loc_2.data = "echo=hello";
            infoLoader.load(_loc_2);
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.BUFFERING});
            return;
        }// end function

        protected function ioErrorHandler(event:IOErrorEvent) : void
        {
            model.sendEvent(ModelEvent.ERROR, {message:"播放地址出错了!"});
            return;
        }// end function

        protected function xml1LoadHandler(event:Event) : void
        {
            var _loc_3:String = null;
            infoLoader.removeEventListener(Event.COMPLETE, this.xml1LoadHandler);
            var _loc_2:* = infoLoader.data as String;
            if (_loc_2)
            {
                _loc_3 = _loc_2;
                infoLoader.load(new URLRequest(_loc_3));
                infoLoader.addEventListener(Event.COMPLETE, this.flvXMLLoaderHandler);
                infoLoader.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            }
            return;
        }// end function

        protected function getXML1Url(param1:String) : String
        {
            return "/" + param1 + "/sixroom/";
        }// end function

    }
}
