package com.jeroenwijering.plugins
{
    import com.jeroenwijering.events.*;
    import com.jeroenwijering.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;

    public class Display extends Object implements PluginInterface
    {
        public var config:Object;
        private var margins:Array;
        public var clip:MovieClip;
        private var state:String;
        private var loader:Loader;
        private var timeout:Number;
        private var view:AbstractView;
        private var colors:Object;
        private var ICONS:Array;

        public function Display() : void
        {
            this.config = {};
            this.ICONS = new Array("playIcon", "errorIcon", "bufferIcon", "linkIcon", "muteIcon", "fullscreenIcon", "nextIcon", "titleIcon");
            return;
        }// end function

        private function stateHandler(event:Event = null) : void
        {
            switch(this.view.config["state"])
            {
                case ModelStates.PLAYING:
                {
                    if (this.view.config["mute"] == true)
                    {
                        this.setIcon("muteIcon");
                    }
                    else
                    {
                        this.setIcon();
                    }
                    break;
                }
                case ModelStates.BUFFERING:
                {
                    if (event && event["data"].oldstate == ModelStates.PLAYING)
                    {
                        this.timeout = setTimeout(this.setIcon, 1500, "bufferIcon");
                    }
                    else
                    {
                        this.setIcon("bufferIcon");
                    }
                    break;
                }
                case ModelStates.IDLE:
                case ModelStates.COMPLETED:
                {
                    if (this.view.config.displayclick == "none" || !this.view.playlist)
                    {
                        this.setIcon();
                    }
                    else if (this.clip.titleIcon && this.view.config["displaytitle"])
                    {
                        this.setTitle();
                        this.setIcon("titleIcon");
                    }
                    else
                    {
                        this.setIcon("playIcon");
                    }
                    break;
                }
                default:
                {
                    this.setIcon(this.view.config.displayclick + "Icon");
                    break;
                    break;
                }
            }
            return;
        }// end function

        private function setTitle() : void
        {
            var _loc_1:* = this.clip.titleIcon;
            _loc_1.txt.autoSize = "left";
            _loc_1.txt.text = this.view.playlist[this.view.config["item"]]["title"];
            if (_loc_1.txt.width + _loc_1.icn.width + 60 > this.config["width"])
            {
                _loc_1.bck.width = this.config["width"] - 60;
                _loc_1.txt.autoSize = "none";
                _loc_1.txt.width = _loc_1.bck.width - _loc_1.icn.width - 20;
            }
            else
            {
                _loc_1.bck.width = _loc_1.txt.width + _loc_1.icn.width + 20;
            }
            _loc_1.bck.x = (-_loc_1.bck.width) / 2;
            _loc_1.icn.x = _loc_1.bck.x;
            _loc_1.txt.x = _loc_1.icn.x + _loc_1.icn.width;
            return;
        }// end function

        private function errorHandler(param1:Object) : void
        {
            if (this.view.config["icons"] == true)
            {
                this.setIcon("errorIcon");
                Draw.set(this.clip.errorIcon.txt, "text", param1.data.message);
            }
            return;
        }// end function

        public function initializePlugin(param1:AbstractView) : void
        {
            var _loc_2:ColorTransform = null;
            this.view = param1;
            this.view.addControllerListener(ControllerEvent.ERROR, this.errorHandler);
            this.view.addControllerListener(ControllerEvent.MUTE, this.stateHandler);
            this.view.addControllerListener(ControllerEvent.PLAYLIST, this.stateHandler);
            this.view.addControllerListener(ControllerEvent.RESIZE, this.resizeHandler);
            this.view.addModelListener(ModelEvent.BUFFER, this.bufferHandler);
            this.view.addModelListener(ModelEvent.ERROR, this.errorHandler);
            this.view.addModelListener(ModelEvent.STATE, this.stateHandler);
            if (this.view.config["screencolor"])
            {
                _loc_2 = new ColorTransform();
                _loc_2.color = uint("0x" + this.view.config["screencolor"]);
                this.clip.back.transform.colorTransform = _loc_2;
            }
            if (this.view.config["displayclick"] != "none")
            {
                this.clip.addEventListener(MouseEvent.CLICK, this.clickHandler);
                this.clip.buttonMode = true;
            }
            if (this.clip.logo)
            {
                this.logoSetter();
            }
            this.stateHandler();
            return;
        }// end function

        private function logoSetter() : void
        {
            this.margins = new Array(this.clip.logo.x, this.clip.logo.y, this.clip.back.width - this.clip.logo.x - this.clip.logo.width, this.clip.back.height - this.clip.logo.y - this.clip.logo.height);
            if (this.clip.logo.width == 10)
            {
                Draw.clear(this.clip.logo);
            }
            if (this.view.config["logo"])
            {
                Draw.clear(this.clip.logo);
                this.loader = new Loader();
                this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loaderHandler);
                this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.loaderHandler);
                this.clip.logo.addChild(this.loader);
                this.loader.load(new URLRequest(this.view.config["logo"]));
            }
            return;
        }// end function

        private function clickHandler(event:MouseEvent) : void
        {
            if (this.view.config["state"] == ModelStates.IDLE)
            {
                this.view.sendEvent("PLAY");
            }
            else if (this.view.config["state"] == ModelStates.PLAYING && this.view.config["mute"] == true)
            {
                this.view.sendEvent("MUTE");
            }
            else
            {
                this.view.sendEvent(this.view.config["displayclick"]);
            }
            return;
        }// end function

        private function resizeHandler(event:ControllerEvent) : void
        {
            var _loc_2:String = null;
            if (this.config["height"] > 11)
            {
                this.clip.visible = true;
            }
            else
            {
                this.clip.visible = false;
            }
            Draw.pos(this.clip, this.config["x"], this.config["y"]);
            Draw.size(this.clip.back, this.config["width"], this.config["height"]);
            Draw.size(this.clip.masker, this.config["width"], this.config["height"]);
            for (_loc_2 in this.ICONS)
            {
                
                Draw.pos(this.clip[this.ICONS[_loc_2]], this.config["width"] / 2, this.config["height"] / 2);
            }
            if (this.clip.logo)
            {
                this.loaderHandler();
            }
            return;
        }// end function

        private function loaderHandler(event:Event = null) : void
        {
            if (this.margins[0] > this.margins[2])
            {
                this.clip.logo.x = this.clip.back.width - this.margins[2] - this.clip.logo.width;
            }
            else
            {
                this.clip.logo.x = this.margins[0];
            }
            if (this.margins[1] > this.margins[3])
            {
                this.clip.logo.y = this.clip.back.height - this.margins[3] - this.clip.logo.height;
            }
            else
            {
                this.clip.logo.y = this.margins[1];
            }
            return;
        }// end function

        private function bufferHandler(event:ModelEvent) : void
        {
            if (event.data.percentage > 0)
            {
                Draw.set(this.clip.bufferIcon.txt, "text", Strings.zero(event.data.percentage));
            }
            else
            {
                Draw.set(this.clip.bufferIcon.txt, "text", "");
            }
            return;
        }// end function

        private function setIcon(param1:String = ) : void
        {
            var _loc_2:String = null;
            clearTimeout(this.timeout);
            for (_loc_2 in this.ICONS)
            {
                
                if (this.clip[this.ICONS[_loc_2]])
                {
                    if (param1 == this.ICONS[_loc_2] && this.view.config["icons"] == true)
                    {
                        this.clip[this.ICONS[_loc_2]].visible = true;
                        continue;
                    }
                    this.clip[this.ICONS[_loc_2]].visible = false;
                }
            }
            return;
        }// end function

    }
}
