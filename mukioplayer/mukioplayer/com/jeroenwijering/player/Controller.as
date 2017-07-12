package com.jeroenwijering.player
{
    import com.jeroenwijering.events.*;
    import com.jeroenwijering.parsers.*;
    import com.jeroenwijering.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;

    public class Controller extends EventDispatcher
    {
        private var config:Object;
        private var loader:URLLoader;
        private var EXTENSIONS:Object;
        public var playlist:Array;
        private var randomizer:Randomizer;
        private var view:View;
        private var model:Model;
        private var sploader:SPLoader;
        private var ELEMENTS:Object;
        private var skin:MovieClip;
        private var REDIRECTS:Object;

        public function Controller(param1:Object, param2:MovieClip, param3:SPLoader) : void
        {
            this.EXTENSIONS = {3g2:"video", 3gp:"video", aac:"video", f4b:"video", f4p:"video", f4v:"video", flv:"video", gif:"image", jpg:"image", m4a:"video", m4v:"video", mov:"video", mp3:"sound", mp4:"video", png:"image", rbs:"sound", sdp:"video", swf:"image", vp6:"video"};
            this.ELEMENTS = {author:undefined, date:undefined, description:undefined, duration:0, file:undefined, image:undefined, link:undefined, start:0, streamer:undefined, tags:undefined, title:undefined, type:undefined, vid:undefined, cid:undefined, cfile:undefined, bnico:undefined};
            this.REDIRECTS = {bitgravity:{flashvar:"startparam", model:"http", value:"starttime"}, edgecast:{flashvar:"startparam", model:"http", value:"ec_seek"}, fcsubscribe:{flashvar:"subscribe", model:"rtmp", value:true}, flvseek:{flashvar:"startparam", model:"http", value:"fs"}, highwinds:{flashvar:"loadbalance", model:"rtmp", value:true}, lighttpd:{flashvar:"startparam", model:"http", value:"start"}, vdox:{flashvar:"loadbalance", model:"rtmp", value:true}};
            this.config = param1;
            this.skin = param2;
            this.sploader = param3;
            this.loader = new URLLoader();
            this.loader.addEventListener(Event.COMPLETE, this.loaderHandler);
            this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.errorHandler);
            this.loader.addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
            return;
        }// end function

        private function stateHandler(event:ModelEvent) : void
        {
            if (event.data.newstate == ModelStates.COMPLETED)
            {
                switch(this.config["repeat"])
                {
                    case "single":
                    {
                        this.playHandler(new ViewEvent(ViewEvent.PLAY, {state:true}));
                        break;
                    }
                    case "always":
                    {
                        if (this.playlist.length == 1)
                        {
                            this.playHandler(new ViewEvent(ViewEvent.PLAY, {state:true}));
                        }
                        else
                        {
                            this.nextHandler();
                        }
                        break;
                    }
                    case "list":
                    {
                        if (this.config["shuffle"] == true && this.randomizer.length > 0 || this.config["shuffle"] == false && this.config["item"] < (this.playlist.length - 1))
                        {
                            this.nextHandler();
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return;
        }// end function

        private function itemHandler(event:ViewEvent) : void
        {
            var _loc_2:* = event.data.index;
            if (this.playlist && this.playlist[_loc_2])
            {
                if (_loc_2 < 0)
                {
                    this.playItem(0);
                }
                else if (_loc_2 > (this.playlist.length - 1))
                {
                    this.playItem((this.playlist.length - 1));
                }
                else if (!isNaN(_loc_2))
                {
                    this.playItem(_loc_2);
                }
            }
            return;
        }// end function

        public function closeMVC(param1:Model, param2:View) : void
        {
            this.model = param1;
            this.model.addEventListener(ModelEvent.STATE, this.stateHandler);
            this.view = param2;
            this.view.addEventListener(ViewEvent.FULLSCREEN, this.fullscreenHandler);
            this.view.addEventListener(ViewEvent.ITEM, this.itemHandler);
            this.view.addEventListener(ViewEvent.LINK, this.linkHandler);
            this.view.addEventListener(ViewEvent.LOAD, this.loadHandler);
            this.view.addEventListener(ViewEvent.MUTE, this.muteHandler);
            this.view.addEventListener(ViewEvent.NEXT, this.nextHandler);
            this.view.addEventListener(ViewEvent.PLAY, this.playHandler);
            this.view.addEventListener(ViewEvent.PREV, this.prevHandler);
            this.view.addEventListener(ViewEvent.REDRAW, this.redrawHandler);
            this.view.addEventListener(ViewEvent.SEEK, this.seekHandler);
            this.view.addEventListener(ViewEvent.STOP, this.stopHandler);
            this.view.addEventListener(ViewEvent.VOLUME, this.volumeHandler);
            return;
        }// end function

        private function loadHandler(event:ViewEvent) : void
        {
            var _loc_3:String = null;
            var _loc_4:Array = null;
            var _loc_5:Object = null;
            if (this.config["state"] != "IDLE")
            {
                this.stopHandler();
            }
            var _loc_2:* = new Object();
            if (typeof(event.data.object) == "array")
            {
                this.playlistHandler(event.data.object);
            }
            else if (typeof(event.data.object) == "string")
            {
                _loc_2["file"] = event.data.object;
            }
            else if (event.data.object["file"])
            {
                for (_loc_3 in this.ELEMENTS)
                {
                    
                    if (event.data.object[_loc_3])
                    {
                        _loc_2[_loc_3] = Strings.serialize(event.data.object[_loc_3]);
                    }
                }
            }
            if (_loc_2["file"])
            {
                if (this.getModelType(_loc_2, false) == null)
                {
                    this.loader.load(new URLRequest(_loc_2["file"]));
                    return;
                }
                this.playlistHandler(new Array(_loc_2));
            }
            else
            {
                _loc_4 = new Array();
                for each (_loc_5 in event.data.object)
                {
                    
                    _loc_4.push(_loc_5);
                }
                this.playlistHandler(_loc_4);
            }
            return;
        }// end function

        private function getModelType(param1:Object, param2:Boolean) : String
        {
            var _loc_3:Object = null;
            if (!param1["file"])
            {
                return null;
            }
            if (this.REDIRECTS[param1["type"]])
            {
                _loc_3 = this.REDIRECTS[param1["type"]];
                this.config[_loc_3["model"] + "." + _loc_3["flashvar"]] = _loc_3["value"];
                return _loc_3["model"];
            }
            if (param1["type"])
            {
                return param1["type"];
            }
            if (param1["streamer"] && param2)
            {
                if (param1["streamer"].substr(0, 4) == "rtmp")
                {
                    return "rtmp";
                }
                if (param1["streamer"].indexOf("/") != -1)
                {
                    return "http";
                }
                return param1["streamer"];
            }
            else
            {
                if (param1["vid"])
                {
                    return "sina";
                }
                if (param1["file"].indexOf("youtube.com/w") > -1 || param1["file"].indexOf("youtube.com/v") > -1)
                {
                    return "youtube";
                }
                if (param1["file"].indexOf("livestream.com/") > -1)
                {
                    return "livestream";
                }
            }
            return this.EXTENSIONS[param1["file"].substr(-3).toLowerCase()];
        }// end function

        private function fullscreenHandler(event:ViewEvent) : void
        {
            var evt:* = event;
            if (this.skin.stage["displayState"] == "fullScreen")
            {
                this.skin.stage["displayState"] = "normal";
            }
            else
            {
                try
                {
                    this.fullscreenrect();
                }
                catch (err:Error)
                {
                }
                this.skin.stage["displayState"] = "fullScreen";
            }
            return;
        }// end function

        private function volumeHandler(event:ViewEvent) : void
        {
            var _loc_2:* = event.data.percentage;
            if (_loc_2 < 1)
            {
                this.muteHandler(new ViewEvent(ViewEvent.MUTE, {state:true}));
            }
            else if (!isNaN(_loc_2) && _loc_2 < 101)
            {
                if (this.config["mute"] == true)
                {
                    this.muteHandler(new ViewEvent(ViewEvent.MUTE, {state:false}));
                }
                this.config["volume"] = _loc_2;
                Configger.saveCookie("volume", this.config["volume"]);
                this.sendEvent(ControllerEvent.VOLUME, {percentage:_loc_2});
            }
            return;
        }// end function

        private function nextHandler(event:ViewEvent = null) : void
        {
            if (this.playlist && this.config["shuffle"] == true)
            {
                this.playItem(this.randomizer.pick());
            }
            else if (this.playlist && this.config["item"] == (this.playlist.length - 1))
            {
                this.playItem(0);
            }
            else if (this.playlist)
            {
                this.playItem((this.config["item"] + 1));
            }
            return;
        }// end function

        private function playlistHandler(param1:Array) : void
        {
            var _loc_2:* = param1.length - 1;
            while (_loc_2 > -1)
            {
                
                if (!param1[_loc_2]["duration"] || isNaN(param1[_loc_2]["duration"]))
                {
                    param1[_loc_2]["duration"] = 0;
                }
                if (!param1[_loc_2]["start"] || isNaN(param1[_loc_2]["start"]))
                {
                    param1[_loc_2]["start"] = 0;
                }
                if (!param1[_loc_2]["streamer"] && this.config["streamer"])
                {
                    param1[_loc_2]["streamer"] = this.config["streamer"];
                }
                param1[_loc_2]["type"] = this.getModelType(param1[_loc_2], true);
                if (!param1[_loc_2]["type"])
                {
                    param1.splice(_loc_2, 1);
                }
                _loc_2 = _loc_2 - 1;
            }
            if (param1.length > 0)
            {
                this.playlist = param1;
            }
            else
            {
                this.sendEvent(ControllerEvent.ERROR, {message:"No valid media file(s) found."});
                return;
            }
            if (this.config["shuffle"] == true)
            {
                this.randomizer = new Randomizer(this.playlist.length);
                this.config["item"] = this.randomizer.pick();
            }
            else if (this.config["item"] >= this.playlist.length)
            {
                this.config["item"] = this.playlist.length - 1;
            }
            this.sendEvent(ControllerEvent.PLAYLIST, {playlist:this.playlist});
            if (this.config["autostart"] == true)
            {
                this.playItem();
            }
            return;
        }// end function

        private function loaderHandler(event:Event) : void
        {
            var dat:XML;
            var fmt:String;
            var evt:* = event;
            try
            {
                dat = XML(evt.target.data);
                fmt = dat.localName().toLowerCase();
            }
            catch (err:Error)
            {
                sendEvent(ControllerEvent.ERROR, {message:"This playlist is not a valid XML file."});
                return;
            }
            switch(fmt)
            {
                case "rss":
                {
                    this.playlistHandler(RSSParser.parse(dat));
                    break;
                }
                case "playlist":
                {
                    this.playlistHandler(XSPFParser.parse(dat));
                    break;
                }
                case "asx":
                {
                    this.playlistHandler(ASXParser.parse(dat));
                    break;
                }
                case "smil":
                {
                    this.playlistHandler(SMILParser.parse(dat));
                    break;
                }
                case "feed":
                {
                    this.playlistHandler(ATOMParser.parse(dat));
                    break;
                }
                default:
                {
                    this.sendEvent(ControllerEvent.ERROR, {message:"Unknown playlist format: " + fmt});
                    return;
                    break;
                }
            }
            return;
        }// end function

        private function prevHandler(event:ViewEvent) : void
        {
            if (this.config["item"] == 0)
            {
                this.playItem((this.playlist.length - 1));
            }
            else
            {
                this.playItem((this.config["item"] - 1));
            }
            return;
        }// end function

        private function fullscreenrect() : void
        {
            var _loc_1:* = this.skin.parent.localToGlobal(new Point(this.skin.x, this.skin.y));
            this.skin.stage["fullScreenSourceRect"] = new Rectangle(_loc_1.x, _loc_1.y, Capabilities.screenResolutionX, Capabilities.screenResolutionY);
            return;
        }// end function

        private function errorHandler(event:ErrorEvent) : void
        {
            this.sendEvent(ControllerEvent.ERROR, {message:event.text});
            return;
        }// end function

        private function playItem(param1:Number = ) : void
        {
            if (!isNaN(param1))
            {
                this.config["item"] = param1;
            }
            this.sendEvent(ControllerEvent.ITEM, {index:this.config["item"]});
            return;
        }// end function

        private function redrawHandler(event:ViewEvent = null) : void
        {
            var dps:String;
            var evt:* = event;
            try
            {
                dps = this.skin.stage["displayState"];
            }
            catch (err:Error)
            {
            }
            if (dps == "fullScreen")
            {
                this.config["fullscreen"] = true;
                this.sploader.layoutFullscreen();
            }
            else
            {
                this.config["width"] = this.skin.stage.stageWidth;
                this.config["height"] = this.skin.stage.stageHeight - 27;
                this.config["fullscreen"] = false;
                this.sploader.layoutNormal();
            }
            this.sendEvent(ControllerEvent.RESIZE, {fullscreen:this.config["fullscreen"], width:this.config["width"], height:this.config["height"]});
            return;
        }// end function

        private function stopHandler(event:ViewEvent = ) : void
        {
            this.sendEvent(ControllerEvent.STOP);
            return;
        }// end function

        private function muteHandler(event:ViewEvent) : void
        {
            if (event.data.state == true || event.data.state == false)
            {
                if (event.data.state == this.config["mute"])
                {
                    return;
                }
                this.config["mute"] = event.data.state;
            }
            else
            {
                this.config["mute"] = !this.config["mute"];
            }
            Configger.saveCookie("mute", this.config["mute"]);
            this.sendEvent(ControllerEvent.MUTE, {state:this.config["mute"]});
            return;
        }// end function

        private function seekHandler(event:ViewEvent) : void
        {
            var _loc_2:Number = NaN;
            if (this.config["state"] != ModelStates.IDLE && this.playlist[this.config["item"]]["duration"] > 0)
            {
                _loc_2 = event.data.position;
                if (_loc_2 < 1)
                {
                    _loc_2 = 0;
                }
                else if (_loc_2 > (this.playlist[this.config["item"]]["duration"] - 1))
                {
                    _loc_2 = this.playlist[this.config["item"]]["duration"] - 1;
                }
                this.sendEvent(ControllerEvent.SEEK, {position:_loc_2});
            }
            return;
        }// end function

        private function playHandler(event:ViewEvent) : void
        {
            if (this.playlist)
            {
                if (event.data.state != false && this.config["state"] == ModelStates.PAUSED)
                {
                    this.sendEvent(ControllerEvent.PLAY, {state:true});
                }
                else if (event.data.state != false && this.config["state"] == ModelStates.COMPLETED)
                {
                    this.sendEvent(ControllerEvent.SEEK, {position:this.playlist[this.config["item"]]["start"]});
                }
                else if (event.data.state != false && this.config["state"] == ModelStates.IDLE)
                {
                    this.playItem();
                }
                else if (event.data.state != true && (this.config["state"] == ModelStates.PLAYING || this.config["state"] == ModelStates.BUFFERING))
                {
                    this.sendEvent(ControllerEvent.PLAY, {state:false});
                }
            }
            return;
        }// end function

        private function sendEvent(param1:String, param2:Object = ) : void
        {
            Logger.log(param2, param1);
            dispatchEvent(new ControllerEvent(param1, param2));
            return;
        }// end function

        private function linkHandler(event:ViewEvent = null) : void
        {
            var _loc_2:* = this.config["item"];
            if (event && event.data.index)
            {
                _loc_2 = event.data.index;
            }
            var _loc_3:* = this.playlist[_loc_2]["link"];
            if (_loc_3 != null)
            {
                navigateToURL(new URLRequest(_loc_3), this.config["linktarget"]);
            }
            this.playHandler(new ViewEvent(ViewEvent.PLAY, {state:false}));
            return;
        }// end function

    }
}
