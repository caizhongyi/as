package com.jeroenwijering.player
{
    import com.jeroenwijering.events.*;
    import com.jeroenwijering.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;

    public class SPLoader extends EventDispatcher
    {
        private var config:Object;
        private var done:Number = 0;
        private var loader:Loader;
        private var basedir:String = "http://plugins.longtailvideo.com/";
        private var plugins:Array;
        private var player:Player;
        private var skin:MovieClip;

        public function SPLoader(param1:Player) : void
        {
            this.config = param1.config;
            this.skin = param1.skin;
            this.player = param1;
            this.plugins = new Array();
            return;
        }// end function

        public function loadSkin() : void
        {
            if (this.config["skin"])
            {
                this.loadSWF(this.config["skin"], true);
            }
            else
            {
                dispatchEvent(new SPLoaderEvent(SPLoaderEvent.SKIN));
            }
            return;
        }// end function

        public function layoutFullscreen() : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_1:Number = 0;
            while (_loc_1 < this.plugins.length)
            {
                
                if (this.plugins[_loc_1]["position"] == "over" || this.plugins[_loc_1]["position"] == undefined || this.plugins[_loc_1]["position"] == "morespecial" || this.plugins[_loc_1]["name"] == "controlbar" && this.plugins[_loc_1]["position"] != "none")
                {
                    this.plugins[_loc_1]["x"] = 0;
                    this.plugins[_loc_1]["y"] = 0;
                    this.plugins[_loc_1]["width"] = this.skin.stage.stageWidth;
                    this.plugins[_loc_1]["height"] = this.skin.stage.stageHeight;
                    this.plugins[_loc_1]["visible"] = true;
                    if (this.plugins[_loc_1]["position"] == "morespecial")
                    {
                        _loc_2 = this.skin.stage.stageWidth / Player.WIDTH;
                        _loc_3 = this.skin.stage.stageHeight / Player.HEIGHT;
                        if (_loc_2 < _loc_3)
                        {
                            _loc_4 = _loc_2;
                        }
                        else
                        {
                            _loc_4 = _loc_3;
                        }
                        this.plugins[_loc_1]["x"] = (this.skin.stage.stageWidth - Player.WIDTH * _loc_4) / 2;
                        this.plugins[_loc_1]["y"] = (this.skin.stage.stageHeight - Player.HEIGHT * _loc_4) / 2;
                    }
                }
                else if (this.plugins[_loc_1]["position"] == "special")
                {
                    this.plugins[_loc_1]["visible"] = false;
                }
                else
                {
                    this.plugins[_loc_1]["visible"] = false;
                }
                _loc_1 = _loc_1 + 1;
            }
            this.config["width"] = this.skin.stage.stageWidth;
            this.config["height"] = this.skin.stage.stageHeight;
            return;
        }// end function

        private function skinHandler(event:Event) : void
        {
            var skn:MovieClip;
            var newchd:DisplayObject;
            var chd:DisplayObject;
            var idx:Number;
            var evt:* = event;
            try
            {
                skn = evt.target.content["player"];
                while (skn.numChildren > 0)
                {
                    
                    newchd = skn.getChildAt(0);
                    chd = this.skin.getChildByName(newchd.name);
                    if (chd)
                    {
                        idx = this.skin.getChildIndex(chd);
                        this.skin.removeChild(chd);
                        delete this.skin[chd.name];
                        this.skin.addChildAt(newchd, idx);
                        this.skin[newchd.name] = newchd;
                        this.skin.getChildByName(newchd.name).visible = false;
                        continue;
                    }
                    this.skin.addChild(newchd);
                    this.skin[newchd.name] = newchd;
                }
                dispatchEvent(new SPLoaderEvent(SPLoaderEvent.SKIN));
            }
            catch (err:Error)
            {
            }
            return;
        }// end function

        public function getPluginConfig(param1:Object) : Object
        {
            var _loc_2:Number = 0;
            while (_loc_2 < this.plugins.length)
            {
                
                if (this.plugins[_loc_2]["reference"] == param1)
                {
                    return this.plugins[_loc_2];
                }
                _loc_2 = _loc_2 + 1;
            }
            return null;
        }// end function

        private function pluginError(event:ErrorEvent) : void
        {
            var _loc_2:String = this;
            var _loc_3:* = this.done - 1;
            _loc_2.done = _loc_3;
            if (this.done == 0)
            {
                dispatchEvent(new SPLoaderEvent(SPLoaderEvent.PLUGINS));
            }
            return;
        }// end function

        private function pluginHandler(event:Event) : void
        {
            var idx:Number;
            var end:Number;
            var nam:String;
            var evt:* = event;
            try
            {
                idx = evt.target.url.lastIndexOf("/");
                end = evt.target.url.length - 4;
                if (evt.target.url.indexOf("-", end - 5) > -1)
                {
                    end = evt.target.url.indexOf("-", end - 5);
                }
                nam = evt.target.url.substring((idx + 1), end).toLowerCase();
                this.addPlugin(evt.target.content, nam, true);
                evt.target.loader.visible = true;
            }
            catch (err:Error)
            {
            }
            var _loc_3:String = this;
            var _loc_4:* = this.done - 1;
            _loc_3.done = _loc_4;
            if (this.done == 0)
            {
                dispatchEvent(new SPLoaderEvent(SPLoaderEvent.PLUGINS));
            }
            else if (this.done < 0)
            {
                this.player.view.sendEvent("REDRAW");
            }
            return;
        }// end function

        public function loadPlugins() : void
        {
            var _loc_1:Array = null;
            var _loc_2:Number = NaN;
            if (this.config["plugins"])
            {
                _loc_1 = this.config["plugins"].split(",");
                this.done = _loc_1.length;
                _loc_2 = 0;
                while (_loc_2 < _loc_1.length)
                {
                    
                    this.loadSWF(_loc_1[_loc_2], false);
                    _loc_2 = _loc_2 + 1;
                }
            }
            else
            {
                dispatchEvent(new SPLoaderEvent(SPLoaderEvent.PLUGINS));
            }
            return;
        }// end function

        private function skinError(event:IOErrorEvent = null) : void
        {
            dispatchEvent(new SPLoaderEvent(SPLoaderEvent.SKIN));
            return;
        }// end function

        public function getPlugin(param1:String) : Object
        {
            var _loc_2:Number = 0;
            while (_loc_2 < this.plugins.length)
            {
                
                if (this.plugins[_loc_2]["name"] == param1)
                {
                    return this.plugins[_loc_2]["reference"];
                }
                _loc_2 = _loc_2 + 1;
            }
            return null;
        }// end function

        public function layoutNormal() : void
        {
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_1:Object = {x:0, y:0, width:this.config["width"], height:this.config["height"]};
            var _loc_2:* = new Array();
            var _loc_3:* = this.plugins.length - 1;
            while (_loc_3 >= 0)
            {
                
                switch(this.plugins[_loc_3]["position"])
                {
                    case "left":
                    {
                        this.plugins[_loc_3]["x"] = _loc_1.x;
                        this.plugins[_loc_3]["y"] = _loc_1.y;
                        this.plugins[_loc_3]["width"] = this.plugins[_loc_3]["size"];
                        this.plugins[_loc_3]["height"] = _loc_1.height;
                        this.plugins[_loc_3]["visible"] = true;
                        _loc_1.x = _loc_1.x + this.plugins[_loc_3]["size"];
                        _loc_1.width = _loc_1.width - this.plugins[_loc_3]["size"];
                        break;
                    }
                    case "top":
                    {
                        this.plugins[_loc_3]["x"] = _loc_1.x;
                        this.plugins[_loc_3]["y"] = _loc_1.y;
                        this.plugins[_loc_3]["width"] = _loc_1.width;
                        this.plugins[_loc_3]["height"] = this.plugins[_loc_3]["size"];
                        this.plugins[_loc_3]["visible"] = true;
                        _loc_1.y = _loc_1.y + this.plugins[_loc_3]["size"];
                        _loc_1.height = _loc_1.height - this.plugins[_loc_3]["size"];
                        break;
                    }
                    case "right":
                    {
                        this.plugins[_loc_3]["x"] = _loc_1.x + _loc_1.width - this.plugins[_loc_3]["size"];
                        this.plugins[_loc_3]["y"] = _loc_1.y;
                        this.plugins[_loc_3]["width"] = this.plugins[_loc_3]["size"];
                        this.plugins[_loc_3]["height"] = _loc_1.height;
                        this.plugins[_loc_3]["visible"] = true;
                        _loc_1.width = _loc_1.width - this.plugins[_loc_3]["size"];
                        break;
                    }
                    case "bottom":
                    {
                        this.plugins[_loc_3]["x"] = _loc_1.x;
                        this.plugins[_loc_3]["y"] = _loc_1.y + _loc_1.height - this.plugins[_loc_3]["size"];
                        this.plugins[_loc_3]["width"] = _loc_1.width;
                        this.plugins[_loc_3]["height"] = this.plugins[_loc_3]["size"];
                        this.plugins[_loc_3]["visible"] = true;
                        _loc_1.height = _loc_1.height - this.plugins[_loc_3]["size"];
                        break;
                    }
                    case "special":
                    {
                        this.plugins[_loc_3]["x"] = 0;
                        this.plugins[_loc_3]["y"] = 0;
                        this.plugins[_loc_3]["width"] = this.skin.stage.stageWidth;
                        this.plugins[_loc_3]["height"] = this.skin.stage.stageHeight;
                        this.plugins[_loc_3]["visible"] = true;
                        break;
                    }
                    case "morespecial":
                    {
                        this.plugins[_loc_3]["x"] = 0;
                        this.plugins[_loc_3]["y"] = 0;
                        this.plugins[_loc_3]["width"] = Player.WIDTH;
                        this.plugins[_loc_3]["height"] = Player.HEIGHT;
                        this.plugins[_loc_3]["visible"] = true;
                        _loc_5 = this.skin.stage.stageWidth / Player.WIDTH;
                        _loc_6 = this.skin.stage.stageHeight / Player.HEIGHT;
                        if (_loc_5 < _loc_6)
                        {
                            _loc_7 = _loc_5;
                        }
                        else
                        {
                            _loc_7 = _loc_6;
                        }
                        this.plugins[_loc_3]["x"] = (this.skin.stage.stageWidth - Player.WIDTH * _loc_7) / 2;
                        break;
                    }
                    case "none":
                    {
                        this.plugins[_loc_3]["visible"] = false;
                        break;
                    }
                    default:
                    {
                        _loc_2.push(_loc_3);
                        break;
                        break;
                    }
                }
                _loc_3 = _loc_3 - 1;
            }
            var _loc_4:Number = 0;
            while (_loc_4 < _loc_2.length)
            {
                
                this.plugins[_loc_2[_loc_4]]["x"] = _loc_1.x;
                this.plugins[_loc_2[_loc_4]]["y"] = _loc_1.y;
                this.plugins[_loc_2[_loc_4]]["width"] = _loc_1.width;
                this.plugins[_loc_2[_loc_4]]["height"] = _loc_1.height;
                this.plugins[_loc_2[_loc_4]]["visible"] = true;
                _loc_4 = _loc_4 + 1;
            }
            this.config["width"] = _loc_1.width;
            this.config["height"] = _loc_1.height;
            return;
        }// end function

        public function addPlugin(param1:Object, param2:String, param3:Boolean = false) : void
        {
            var str:String;
            var clp:DisplayObject;
            var org:String;
            var pgi:* = param1;
            var nam:* = param2;
            var ext:* = param3;
            var obj:Object;
            var cbr:* = this.skin.getChildByName("controlbar");
            var dck:* = this.skin.getChildByName("dock");
            if (nam == "controlbar")
            {
                this.config["controlbar.position"] = this.config["controlbar"];
                this.config["controlbar.size"] = cbr.height;
                this.config["controlbar.margin"] = cbr.x;
            }
            else if (nam == "playlist")
            {
                this.config["playlist.position"] = this.config["playlist"];
                this.config["playlist.size"] = this.config["playlistsize"];
            }
            else if (nam == "commentlistsender")
            {
                this.config["commentlistsender.position"] = "special";
            }
            else if (nam == "commentview")
            {
                this.config["commentview.position"] = "morespecial";
            }
            try
            {
                var _loc_5:int = 0;
                var _loc_6:* = pgi.config;
                while (_loc_6 in _loc_5)
                {
                    
                    org = _loc_6[_loc_5];
                    obj[org] = pgi.config[org];
                }
            }
            catch (err:Error)
            {
            }
            var _loc_5:int = 0;
            var _loc_6:* = this.config;
            while (_loc_6 in _loc_5)
            {
                
                str = _loc_6[_loc_5];
                if (str.indexOf(nam + ".") == 0)
                {
                    obj[str.substring((nam.length + 1))] = this.config[str];
                }
            }
            if (ext == true)
            {
                clp = DisplayObject(pgi);
                this.skin.addChild(clp);
            }
            else if (this.skin.getChildByName(nam))
            {
                clp = this.skin.getChildByName(nam);
            }
            else
            {
                clp = new MovieClip();
                clp.name = nam;
                if (nam == "commentlistsender")
                {
                    clp = pgi.clip;
                    this.skin.stage.addChild(clp);
                }
                else if (nam == "commentview")
                {
                    clp = pgi.clip;
                    this.skin.addChild(clp);
                }
                else
                {
                    this.skin.addChildAt(clp, 1);
                }
            }
            this.plugins.push(obj);
            try
            {
                pgi.config = obj;
                pgi.clip = clp;
            }
            catch (err:Error)
            {
            }
            if (cbr)
            {
                this.skin.setChildIndex(cbr, (this.skin.numChildren - 1));
            }
            if (dck)
            {
                this.skin.setChildIndex(dck, (this.skin.numChildren - 1));
            }
            pgi.initializePlugin(this.player.view);
            return;
        }// end function

        public function loadPlugin(param1:String, param2:String = null) : void
        {
            var _loc_3:Array = null;
            var _loc_4:String = null;
            var _loc_5:Array = null;
            if (param2 != null && param2 != "")
            {
                _loc_3 = param2.split("&");
                for (_loc_4 in _loc_3)
                {
                    
                    _loc_5 = _loc_3[_loc_4].split("=");
                    this.config[_loc_5[0]] = Strings.serialize(_loc_5[1]);
                }
            }
            this.loadSWF(param1, false);
            return;
        }// end function

        private function loadSWF(param1:String, param2:Boolean) : void
        {
            var _loc_4:LoaderContext = null;
            if (param1.substr(-4) == ".swf")
            {
                param1 = param1.substr(0, param1.length - 4);
            }
            var _loc_3:* = new Loader();
            if (param2)
            {
                _loc_3.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.skinError);
                _loc_3.contentLoaderInfo.addEventListener(Event.COMPLETE, this.skinHandler);
            }
            else
            {
                _loc_3.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.pluginError);
                _loc_3.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.pluginError);
                _loc_3.contentLoaderInfo.addEventListener(Event.COMPLETE, this.pluginHandler);
            }
            param1 = param1 + ".swf";
            if (this.skin.loaderInfo.url.indexOf("http") == 0)
            {
                _loc_4 = new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain);
                if (param2 || param1.indexOf("/") > -1)
                {
                    _loc_3.load(new URLRequest(param1), _loc_4);
                }
                else
                {
                    _loc_3.load(new URLRequest(this.basedir + param1), _loc_4);
                }
            }
            else
            {
                _loc_3.load(new URLRequest(param1));
            }
            return;
        }// end function

    }
}
