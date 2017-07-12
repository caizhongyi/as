package com.jeroenwijering.player
{
    import com.jeroenwijering.events.*;
    import com.jeroenwijering.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.system.*;
    import flash.ui.*;
    import flash.utils.*;

    public class View extends AbstractView
    {
        private var _skin:MovieClip;
        private var _config:Object;
        private var ready:Boolean;
        private var model:Model;
        private var context:ContextMenu;
        private var sploader:SPLoader;
        private var controller:Controller;
        private var listeners:Array;

        public function View(param1:Object, param2:MovieClip, param3:SPLoader, param4:Controller, param5:Model) : void
        {
            Security.allowDomain("*");
            this._config = param1;
            this._config["client"] = "FLASH " + Capabilities.version;
            this._skin = param2;
            this._skin.stage.scaleMode = "noScale";
            this._skin.stage.align = "TL";
            this._skin.stage.addEventListener(Event.RESIZE, this.resizeHandler);
            this._skin.stage.addEventListener(FullScreenEvent.FULL_SCREEN, this.resizeHandler);
            this.sploader = param3;
            this.controller = param4;
            this.model = param5;
            this.setListening();
            this.listeners = new Array();
            return;
        }// end function

        private function setListening() : void
        {
            this.addControllerListener(ControllerEvent.ERROR, this.setController);
            this.addControllerListener(ControllerEvent.ITEM, this.setController);
            this.addControllerListener(ControllerEvent.MUTE, this.setController);
            this.addControllerListener(ControllerEvent.PLAY, this.setController);
            this.addControllerListener(ControllerEvent.PLAYLIST, this.setController);
            this.addControllerListener(ControllerEvent.RESIZE, this.setController);
            this.addControllerListener(ControllerEvent.SEEK, this.setController);
            this.addControllerListener(ControllerEvent.STOP, this.setController);
            this.addControllerListener(ControllerEvent.VOLUME, this.setController);
            this.addModelListener(ModelEvent.BUFFER, this.setModel);
            this.addModelListener(ModelEvent.ERROR, this.setModel);
            this.addModelListener(ModelEvent.LOADED, this.setModel);
            this.addModelListener(ModelEvent.META, this.setModel);
            this.addModelListener(ModelEvent.STATE, this.setModel);
            this.addModelListener(ModelEvent.TIME, this.setModel);
            this.addViewListener(ViewEvent.FULLSCREEN, this.setView);
            this.addViewListener(ViewEvent.ITEM, this.setView);
            this.addViewListener(ViewEvent.LINK, this.setView);
            this.addViewListener(ViewEvent.LOAD, this.setView);
            this.addViewListener(ViewEvent.MUTE, this.setView);
            this.addViewListener(ViewEvent.NEXT, this.setView);
            this.addViewListener(ViewEvent.PLAY, this.setView);
            this.addViewListener(ViewEvent.PREV, this.setView);
            this.addViewListener(ViewEvent.REDRAW, this.setView);
            this.addViewListener(ViewEvent.SEEK, this.setView);
            this.addViewListener(ViewEvent.STOP, this.setView);
            this.addViewListener(ViewEvent.TRACE, this.setView);
            this.addViewListener(ViewEvent.VOLUME, this.setView);
            return;
        }// end function

        private function addJSControllerListener(param1:String, param2:String) : Boolean
        {
            this.listeners.push({target:"CONTROLLER", type:param1.toUpperCase(), callee:param2});
            return true;
        }// end function

        private function addJSViewListener(param1:String, param2:String) : Boolean
        {
            this.listeners.push({target:"VIEW", type:param1.toUpperCase(), callee:param2});
            return true;
        }// end function

        private function forward(param1:String, param2:String, param3:Object) : void
        {
            var _loc_5:String = null;
            var _loc_6:String = null;
            var _loc_4:String = "";
            for (_loc_5 in param3)
            {
                
                _loc_4 = _loc_4 + (_loc_5 + ":" + param3[_loc_5] + ",");
            }
            if (_loc_4.length > 0)
            {
                _loc_4 = "(" + _loc_4.substr(0, (_loc_4.length - 1)) + ")";
            }
            if (!param3)
            {
                param3 = new Object();
            }
            param3.id = this.config["id"];
            param3.client = this.config["client"];
            param3.version = this.config["version"];
            for (_loc_6 in this.listeners)
            {
                
                if (this.listeners[_loc_6]["target"] == param1 && this.listeners[_loc_6]["type"] == param2)
                {
                    ExternalInterface.call(this.listeners[_loc_6]["callee"], param3);
                }
            }
            return;
        }// end function

        private function getPlaylist() : Array
        {
            var _loc_3:Number = NaN;
            var _loc_4:String = null;
            var _loc_1:* = new Array();
            var _loc_2:* = new Object();
            if (this.controller.playlist)
            {
                _loc_3 = 0;
                while (_loc_3 < this.controller.playlist.length)
                {
                    
                    _loc_2 = new Object();
                    for (_loc_4 in this.controller.playlist[_loc_3])
                    {
                        
                        if (_loc_4.indexOf(".") == -1)
                        {
                            _loc_2[_loc_4] = this.controller.playlist[_loc_3][_loc_4];
                        }
                    }
                    _loc_1.push(_loc_2);
                    _loc_3 = _loc_3 + 1;
                }
            }
            return _loc_1;
        }// end function

        override public function get config() : Object
        {
            return this._config;
        }// end function

        private function addJSModelListener(param1:String, param2:String) : Boolean
        {
            this.listeners.push({target:"MODEL", type:param1.toUpperCase(), callee:param2});
            return true;
        }// end function

        private function removeJSListener(param1:String, param2:String, param3:String) : void
        {
            var _loc_4:Number = 0;
            while (_loc_4 < this.listeners.length)
            {
                
                if (this.listeners[_loc_4]["target"] == param1 && this.listeners[_loc_4]["type"] == param2 && this.listeners[_loc_4]["callee"] == param3)
                {
                    this.listeners.splice(_loc_4, 1);
                    return;
                }
                _loc_4 = _loc_4 + 1;
            }
            return;
        }// end function

        private function getConfig() : Object
        {
            var _loc_2:String = null;
            var _loc_1:* = new Object();
            for (_loc_2 in this._config)
            {
                
                if (_loc_2.indexOf(".") == -1 && this._config[_loc_2] != undefined)
                {
                    _loc_1[_loc_2] = this._config[_loc_2];
                }
            }
            return _loc_1;
        }// end function

        public function playerReady() : void
        {
            if (ExternalInterface.available && this._skin.loaderInfo.url.indexOf("http") == 0 && this.ready != true)
            {
                this.ready = true;
                setTimeout(this.playerReadyPing, 50);
            }
            return;
        }// end function

        public function getJSPluginConfig(param1:String) : Object
        {
            var s:String;
            var plg:Object;
            var cfg:Object;
            var nam:* = param1;
            try
            {
                plg = this.getPlugin(nam);
                cfg = this.getPluginConfig(plg);
            }
            catch (err:Error)
            {
                return {error:"plugin not loaded"};
            }
            var obj:* = new Object();
            var _loc_3:int = 0;
            var _loc_4:* = cfg;
            while (_loc_4 in _loc_3)
            {
                
                s = _loc_4[_loc_3];
                if (cfg[s] is String || cfg[s] is Boolean || cfg[s] is Number)
                {
                    obj[s] = cfg[s];
                }
            }
            return obj;
        }// end function

        override public function getPlugin(param1:String) : Object
        {
            return this.sploader.getPlugin(param1);
        }// end function

        override public function get playlist() : Array
        {
            return this.controller.playlist;
        }// end function

        override public function getPluginConfig(param1:Object) : Object
        {
            return this.sploader.getPluginConfig(param1);
        }// end function

        private function playerReadyPing() : void
        {
            try
            {
                if (ExternalInterface.objectID && !this._config["id"])
                {
                    this._config["id"] = ExternalInterface.objectID;
                }
                if (this._config["id"])
                {
                    ExternalInterface.addCallback("addControllerListener", this.addJSControllerListener);
                    ExternalInterface.addCallback("addModelListener", this.addJSModelListener);
                    ExternalInterface.addCallback("addViewListener", this.addJSViewListener);
                    ExternalInterface.addCallback("removeControllerListener", this.removeJSControllerListener);
                    ExternalInterface.addCallback("removeModelListener", this.removeJSModelListener);
                    ExternalInterface.addCallback("removeViewListener", this.removeJSViewListener);
                    ExternalInterface.addCallback("getConfig", this.getConfig);
                    ExternalInterface.addCallback("getPlaylist", this.getPlaylist);
                    ExternalInterface.addCallback("getPluginConfig", this.getJSPluginConfig);
                    ExternalInterface.addCallback("loadPlugin", this.loadPlugin);
                    ExternalInterface.addCallback("sendEvent", this.sendEvent);
                    ExternalInterface.call("playerReady", {id:this.config["id"], client:this.config["client"], version:this.config["version"]});
                }
            }
            catch (err:Error)
            {
            }
            return;
        }// end function

        private function removeJSControllerListener(param1:String, param2:String) : Boolean
        {
            this.removeJSListener("CONTROLLER", param1.toUpperCase(), param2);
            return true;
        }// end function

        override public function removeViewListener(param1:String, param2:Function) : void
        {
            this.removeEventListener(param1.toUpperCase(), param2);
            return;
        }// end function

        private function setController(event:ControllerEvent) : void
        {
            this.forward("CONTROLLER", event.type, event.data);
            return;
        }// end function

        private function removeJSViewListener(param1:String, param2:String) : Boolean
        {
            this.removeJSListener("VIEW", param1.toUpperCase(), param2);
            return true;
        }// end function

        private function setModel(event:ModelEvent) : void
        {
            this.forward("MODEL", event.type, event.data);
            return;
        }// end function

        override public function removeModelListener(param1:String, param2:Function) : void
        {
            this.model.removeEventListener(param1.toUpperCase(), param2);
            return;
        }// end function

        override public function addModelListener(param1:String, param2:Function) : void
        {
            this.model.addEventListener(param1.toUpperCase(), param2);
            return;
        }// end function

        override public function removeControllerListener(param1:String, param2:Function) : void
        {
            this.controller.removeEventListener(param1.toUpperCase(), param2);
            return;
        }// end function

        private function setView(event:ViewEvent) : void
        {
            this.forward("VIEW", event.type, event.data);
            return;
        }// end function

        override public function addControllerListener(param1:String, param2:Function) : void
        {
            this.controller.addEventListener(param1.toUpperCase(), param2);
            return;
        }// end function

        override public function sendEvent(param1:String, param2:Object = ) : void
        {
            param1 = param1.toUpperCase();
            var _loc_3:* = new Object();
            switch(param1)
            {
                case "ITEM":
                {
                    _loc_3["index"] = param2;
                    break;
                }
                case "LINK":
                {
                    _loc_3["index"] = param2;
                    break;
                }
                case "LOAD":
                {
                    _loc_3["object"] = param2;
                    break;
                }
                case "SEEK":
                {
                    _loc_3["position"] = param2;
                    trace("Seek dat[\'position\'] : " + _loc_3["position"]);
                    break;
                }
                case "VOLUME":
                {
                    _loc_3["percentage"] = param2;
                    break;
                }
                default:
                {
                    if (param2 == true || param2 == "true")
                    {
                        _loc_3["state"] = true;
                    }
                    else if (param2 === false || param2 == "false")
                    {
                        _loc_3["state"] = false;
                    }
                    break;
                    break;
                }
            }
            Logger.log(param2, param1);
            dispatchEvent(new ViewEvent(param1, _loc_3));
            return;
        }// end function

        private function resizeHandler(event:Event = ) : void
        {
            dispatchEvent(new ViewEvent(ViewEvent.REDRAW));
            return;
        }// end function

        private function removeJSModelListener(param1:String, param2:String) : Boolean
        {
            this.removeJSListener("MODEL", param1.toUpperCase(), param2);
            return true;
        }// end function

        override public function loadPlugin(param1:String, param2:String = null) : Boolean
        {
            this.sploader.loadPlugin(param1, param2);
            return true;
        }// end function

        override public function addViewListener(param1:String, param2:Function) : void
        {
            this.addEventListener(param1.toUpperCase(), param2);
            return;
        }// end function

        override public function get skin() : MovieClip
        {
            return this._skin;
        }// end function

    }
}
