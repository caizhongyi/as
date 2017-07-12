package com.jeroenwijering.utils
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import org.lala.utils.*;

    public class Configger extends EventDispatcher
    {
        private var config:Object;
        private var reference:Sprite;
        private var loader:URLLoader;

        public function Configger(param1:Sprite) : void
        {
            this.reference = param1;
            return;
        }// end function

        private function compareWrite(param1:Object) : void
        {
            var _loc_2:String = null;
            for (_loc_2 in param1)
            {
                
                this.config[_loc_2.toLowerCase()] = Strings.serialize(param1[_loc_2.toLowerCase()]);
            }
            return;
        }// end function

        public function load(param1:Object) : void
        {
            this.config = param1;
            this.loadCookies();
            return;
        }// end function

        private function loadCookies() : void
        {
            var cookie:SharedObject;
            try
            {
                cookie = SharedObject.getLocal("com.jeroenwijering", "/");
                this.compareWrite(cookie.data);
            }
            catch (e:Error)
            {
            }
            xml = this.reference.root.loaderInfo.parameters["config"];
            if (xml)
            {
                this.loadXML(Strings.decode(xml));
            }
            else
            {
                this.loadFlashvars();
            }
            return;
        }// end function

        private function loadXML(param1:String) : void
        {
            var url:* = param1;
            this.loader = new URLLoader();
            this.loader.addEventListener(Event.COMPLETE, this.xmlHandler);
            try
            {
                this.loader.load(new URLRequest(url));
            }
            catch (err:Error)
            {
                loadFlashvars();
            }
            return;
        }// end function

        private function xmlHandler(event:Event) : void
        {
            var _loc_4:XML = null;
            var _loc_2:* = XML(event.currentTarget.data);
            var _loc_3:* = new Object();
            for each (_loc_4 in _loc_2.children())
            {
                
                _loc_3[_loc_4.name()] = _loc_4.text();
            }
            this.compareWrite(_loc_3);
            this.loadFlashvars();
            return;
        }// end function

        private function loadFlashvars() : void
        {
            this.compareWrite(this.reference.root.loaderInfo.parameters);
            try
            {
                CommentGetter.baseURL = this.reference.root.loaderInfo.url.split(/([\/]+)/)[2];
                CommentGetter.URI_PARENT = this.reference.root.loaderInfo.url.replace(/[^\/]+.swf.*/igm, "");
                trace(CommentGetter.baseURL);
            }
            catch (e:Error)
            {
            }
            dispatchEvent(new Event(Event.COMPLETE));
            return;
        }// end function

        public static function saveCookie(param1:String, param2:Object) : void
        {
            var cookie:SharedObject;
            var prm:* = param1;
            var val:* = param2;
            try
            {
                cookie = SharedObject.getLocal("com.jeroenwijering", "/");
                cookie.data[prm] = val;
                cookie.flush();
            }
            catch (err:Error)
            {
            }
            return;
        }// end function

    }
}
