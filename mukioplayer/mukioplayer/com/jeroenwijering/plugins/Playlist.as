package com.jeroenwijering.plugins
{
    import com.jeroenwijering.events.*;
    import com.jeroenwijering.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;

    public class Playlist extends Object implements PluginInterface
    {
        private var buttons:Array;
        public var config:Object;
        private var active:Number;
        public var clip:MovieClip;
        private var light:ColorTransform;
        private var buttonheight:Number;
        private var proportion:Number;
        private var image:Array;
        private var view:AbstractView;
        private var back:ColorTransform;
        private var front:ColorTransform;
        private var scrollInterval:Number;

        public function Playlist() : void
        {
            this.config = {};
            return;
        }// end function

        private function stateHandler(event:ModelEvent = null) : void
        {
            if (this.config["position"] == "over")
            {
                if (this.view.config["state"] == ModelStates.PLAYING || this.view.config["state"] == ModelStates.PAUSED || this.view.config["state"] == ModelStates.BUFFERING)
                {
                    this.clip.visible = false;
                }
                else
                {
                    this.clip.visible = true;
                }
            }
            return;
        }// end function

        private function soverHandler(event:MouseEvent) : void
        {
            if (this.front)
            {
                this.clip.slider.icon.transform.colorTransform = this.light;
            }
            else
            {
                this.clip.slider.icon.gotoAndStop("over");
            }
            return;
        }// end function

        private function scrollEase(param1:Number = -1, param2:Number = -1) : void
        {
            var _loc_3:* = this.clip.slider;
            if (param1 != -1)
            {
                _loc_3.icon.y = Math.round(param1 - (param1 - _loc_3.icon.y) / 1.5);
                this.clip.list.y = Math.round(param2 - (param2 - this.clip.list.y) / 1.5);
            }
            if (this.clip.list.y > 0 || _loc_3.icon.y < _loc_3.rail.y)
            {
                this.clip.list.y = this.clip.masker.y;
                _loc_3.icon.y = _loc_3.rail.y;
            }
            else if (this.clip.list.y < this.clip.masker.height - this.clip.list.height || _loc_3.icon.y > _loc_3.rail.y + _loc_3.rail.height - _loc_3.icon.height)
            {
                _loc_3.icon.y = _loc_3.rail.y + _loc_3.rail.height - _loc_3.icon.height;
                this.clip.list.y = this.clip.masker.y + this.clip.masker.height - this.clip.list.height;
            }
            return;
        }// end function

        private function soutHandler(event:MouseEvent) : void
        {
            if (this.front)
            {
                this.clip.slider.icon.transform.colorTransform = this.front;
            }
            else
            {
                this.clip.slider.icon.gotoAndStop("out");
            }
            return;
        }// end function

        private function setColors() : void
        {
            if (this.view.config["backcolor"])
            {
                this.back = new ColorTransform();
                this.back.color = uint("0x" + this.view.config["backcolor"].substr(-6));
                this.clip.back.transform.colorTransform = this.back;
                this.clip.slider.back.transform.colorTransform = this.back;
            }
            if (this.view.config["frontcolor"])
            {
                this.front = new ColorTransform();
                this.front.color = uint("0x" + this.view.config["frontcolor"].substr(-6));
                try
                {
                    this.clip.slider.icon.transform.colorTransform = this.front;
                    this.clip.slider.rail.transform.colorTransform = this.front;
                }
                catch (err:Error)
                {
                }
                if (this.view.config["lightcolor"])
                {
                    this.light = new ColorTransform();
                    this.light.color = uint("0x" + this.view.config["lightcolor"].substr(-6));
                }
                else
                {
                    this.light = this.front;
                }
            }
            return;
        }// end function

        private function scrollHandler() : void
        {
            var _loc_1:* = this.clip.slider;
            var _loc_2:* = _loc_1.mouseY - _loc_1.rail.y;
            var _loc_3:* = _loc_2 - _loc_1.icon.height / 2;
            var _loc_4:* = this.clip.masker.y + this.clip.masker.height / 2 - this.proportion * _loc_2;
            this.scrollEase(_loc_3, _loc_4);
            return;
        }// end function

        private function playlistHandler(event:ControllerEvent = null) : void
        {
            clearInterval(this.scrollInterval);
            this.active = undefined;
            this.buildList(true);
            this.resizeHandler();
            return;
        }// end function

        private function outHandler(event:MouseEvent) : void
        {
            var _loc_3:String = null;
            var _loc_2:* = Number(event.target.name);
            if (this.front && this.back)
            {
                for (_loc_3 in this.view.playlist[_loc_2])
                {
                    
                    if (this.buttons[_loc_2].c[_loc_3] && typeof(this.buttons[_loc_2].c[_loc_3]) == "object")
                    {
                        if (_loc_2 == this.active)
                        {
                            this.buttons[_loc_2].c[_loc_3].textColor = this.light.color;
                            continue;
                        }
                        this.buttons[_loc_2].c[_loc_3].textColor = this.front.color;
                    }
                }
                this.buttons[_loc_2].c["back"].transform.colorTransform = this.back;
            }
            if (_loc_2 == this.active)
            {
                this.buttons[_loc_2].c.gotoAndStop("active");
            }
            else
            {
                this.buttons[_loc_2].c.gotoAndStop("out");
            }
            return;
        }// end function

        private function overHandler(event:MouseEvent) : void
        {
            var _loc_3:String = null;
            var _loc_2:* = Number(event.target.name);
            if (this.front && this.back)
            {
                for (_loc_3 in this.view.playlist[_loc_2])
                {
                    
                    if (this.buttons[_loc_2].c[_loc_3] && typeof(this.buttons[_loc_2].c[_loc_3]) == "object")
                    {
                        this.buttons[_loc_2].c[_loc_3].textColor = this.back.color;
                    }
                }
                this.buttons[_loc_2].c["back"].transform.colorTransform = this.light;
            }
            this.buttons[_loc_2].c.gotoAndStop("over");
            return;
        }// end function

        private function clickHandler(event:MouseEvent) : void
        {
            this.view.sendEvent("item", Number(event.target.name));
            return;
        }// end function

        public function initializePlugin(param1:AbstractView) : void
        {
            var vie:* = param1;
            this.view = vie;
            this.view.addControllerListener(ControllerEvent.ITEM, this.itemHandler);
            this.view.addControllerListener(ControllerEvent.PLAYLIST, this.playlistHandler);
            this.view.addControllerListener(ControllerEvent.RESIZE, this.resizeHandler);
            this.view.addModelListener(ModelEvent.STATE, this.stateHandler);
            this.buttonheight = this.clip.list.button.height;
            this.clip.list.button.visible = false;
            this.clip.list.mask = this.clip.masker;
            this.clip.list.addEventListener(MouseEvent.CLICK, this.clickHandler);
            this.clip.list.addEventListener(MouseEvent.MOUSE_OVER, this.overHandler);
            this.clip.list.addEventListener(MouseEvent.MOUSE_OUT, this.outHandler);
            this.clip.slider.buttonMode = true;
            this.clip.slider.mouseChildren = false;
            this.clip.slider.addEventListener(MouseEvent.MOUSE_DOWN, this.sdownHandler);
            this.clip.slider.addEventListener(MouseEvent.MOUSE_OVER, this.soverHandler);
            this.clip.slider.addEventListener(MouseEvent.MOUSE_OUT, this.soutHandler);
            this.clip.slider.visible = false;
            this.buttons = new Array();
            try
            {
                this.image = new Array(this.clip.list.button.image.width, this.clip.list.button.image.height);
            }
            catch (err:Error)
            {
            }
            if (this.clip.list.button["back"])
            {
                this.setColors();
            }
            return;
        }// end function

        private function setContents(param1:Number) : void
        {
            var itm:String;
            var img:MovieClip;
            var msk:Sprite;
            var ldr:Loader;
            var idx:* = param1;
            var _loc_3:int = 0;
            var _loc_4:* = this.view.playlist[idx];
            do
            {
                
                itm = _loc_4[_loc_3];
                this.buttons[idx].c.gotoAndStop(0);
                if (!this.buttons[idx].c[itm] || !this.view.playlist[idx][itm])
                {
                    ;
                }
                else if (itm == "image")
                {
                    if (this.config["thumbs"] != false && this.view.config["playlist"] != "none" && (this.view.playlist[idx]["image"] || this.view.playlist[idx]["playlist.image"]))
                    {
                        img = this.buttons[idx].c.image;
                        msk = Draw.rect(this.buttons[idx].c, "0xFF0000", img.width, img.height, img.x, img.y);
                        ldr = new Loader();
                        img.mask = msk;
                        img.addChild(ldr);
                        ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loaderHandler);
                        if (this.view.playlist[idx]["playlist.image"])
                        {
                            ldr.load(new URLRequest(this.view.playlist[idx]["playlist.image"]));
                        }
                        else
                        {
                            ldr.load(new URLRequest(this.view.playlist[idx]["image"]));
                        }
                    }
                }
                else if (itm == "duration")
                {
                    if (this.view.playlist[idx][itm] > 0)
                    {
                        this.buttons[idx].c[itm].htmlText = "<b>" + Strings.digits(this.view.playlist[idx][itm]) + "</b>";
                        if (this.front)
                        {
                            this.buttons[idx].c[itm].textColor = this.front.color;
                        }
                    }
                }
                else
                {
                    try
                    {
                        if (itm == "description")
                        {
                            this.buttons[idx].c[itm].htmlText = this.view.playlist[idx][itm];
                        }
                        else if (itm == "title")
                        {
                            this.buttons[idx].c[itm].htmlText = "<b>" + this.view.playlist[idx][itm] + "</b>";
                        }
                        else
                        {
                            this.buttons[idx].c[itm].text = this.view.playlist[idx][itm];
                        }
                        if (this.front)
                        {
                            this.buttons[idx].c[itm].textColor = this.front.color;
                        }
                    }
                    catch (e:Error)
                    {
                    }
                }
            }while (_loc_4 in _loc_3)
            if (this.buttons[idx].c["image"] && (!this.view.playlist[idx]["image"] || this.config["thumbs"] == false))
            {
                this.buttons[idx].c["image"].visible = false;
            }
            if (this.back)
            {
                this.buttons[idx].c["back"].transform.colorTransform = this.back;
            }
            return;
        }// end function

        private function buildSlider() : void
        {
            var _loc_1:* = this.clip.slider;
            _loc_1.visible = true;
            _loc_1.x = this.clip.back.width - _loc_1.width;
            var _loc_2:* = this.clip.back.height - _loc_1.height - _loc_1.y;
            _loc_1.back.height = _loc_1.back.height + _loc_2;
            _loc_1.rail.height = _loc_1.rail.height + _loc_2;
            _loc_1.icon.height = Math.round(_loc_1.rail.height / this.proportion);
            return;
        }// end function

        private function supHandler(event:MouseEvent) : void
        {
            clearInterval(this.scrollInterval);
            this.clip.stage.removeEventListener(MouseEvent.MOUSE_UP, this.supHandler);
            return;
        }// end function

        private function sdownHandler(event:MouseEvent) : void
        {
            clearInterval(this.scrollInterval);
            this.clip.stage.addEventListener(MouseEvent.MOUSE_UP, this.supHandler);
            this.scrollHandler();
            this.scrollInterval = setInterval(this.scrollHandler, 50);
            return;
        }// end function

        private function itemHandler(event:ControllerEvent) : void
        {
            var itm:String;
            var act:String;
            var evt:* = event;
            var idx:* = this.view.config["item"];
            clearInterval(this.scrollInterval);
            if (this.proportion > 1.01)
            {
                this.scrollInterval = setInterval(this.scrollEase, 50, idx * this.buttonheight / this.proportion, (-idx) * this.buttonheight + this.clip.masker.y);
            }
            if (this.light)
            {
                var _loc_3:int = 0;
                var _loc_4:* = this.view.playlist[idx];
                do
                {
                    
                    itm = _loc_4[_loc_3];
                    if (this.buttons[idx].c[itm])
                    {
                        try
                        {
                            this.buttons[idx].c[itm].textColor = this.light.color;
                        }
                        catch (err:Error)
                        {
                        }
                    }
                }while (_loc_4 in _loc_3)
            }
            if (this.back)
            {
                this.buttons[idx].c["back"].transform.colorTransform = this.back;
            }
            this.buttons[idx].c.gotoAndStop("active");
            if (!isNaN(this.active))
            {
                if (this.front)
                {
                    var _loc_3:int = 0;
                    var _loc_4:* = this.view.playlist[this.active];
                    do
                    {
                        
                        act = _loc_4[_loc_3];
                        if (this.buttons[this.active].c[act])
                        {
                            try
                            {
                                this.buttons[this.active].c[act].textColor = this.front.color;
                            }
                            catch (err:Error)
                            {
                            }
                        }
                    }while (_loc_4 in _loc_3)
                }
                this.buttons[this.active].c.gotoAndStop("out");
            }
            this.active = idx;
            return;
        }// end function

        private function buildList(param1:Boolean) : void
        {
            var _loc_5:Number = NaN;
            var _loc_6:MovieClip = null;
            var _loc_7:Stacker = null;
            if (!this.view.playlist)
            {
                return;
            }
            var _loc_2:* = this.clip.back.width;
            var _loc_3:* = this.clip.back.height;
            this.clip.masker.height = _loc_3;
            this.clip.masker.width = _loc_2;
            this.proportion = this.view.playlist.length * this.buttonheight / _loc_3;
            if (this.proportion > 1.01)
            {
                _loc_2 = _loc_2 - this.clip.slider.width;
                this.buildSlider();
            }
            else
            {
                this.clip.slider.visible = false;
            }
            if (param1)
            {
                this.clip.list.y = this.clip.masker.y;
                _loc_5 = 0;
                while (_loc_5 < this.buttons.length)
                {
                    
                    this.clip.list.removeChild(this.buttons[_loc_5].c);
                    _loc_5 = _loc_5 + 1;
                }
                this.buttons = new Array();
            }
            else if (this.proportion > 1)
            {
                this.scrollEase();
            }
            var _loc_4:Number = 0;
            while (_loc_4 < this.view.playlist.length)
            {
                
                if (param1)
                {
                    _loc_6 = Draw.clone(this.clip.list.button, true);
                    _loc_7 = new Stacker(_loc_6);
                    _loc_6.y = _loc_4 * this.buttonheight;
                    _loc_6.buttonMode = true;
                    _loc_6.mouseChildren = false;
                    _loc_6.name = _loc_4.toString();
                    this.buttons.push({c:_loc_6, s:_loc_7});
                    this.setContents(_loc_4);
                }
                this.buttons[_loc_4].s.rearrange(_loc_2);
                _loc_4 = _loc_4 + 1;
            }
            return;
        }// end function

        private function resizeHandler(event:ControllerEvent = null) : void
        {
            this.clip.x = this.config["x"];
            this.clip.y = this.config["y"];
            this.clip.back.width = this.config["width"];
            this.clip.back.height = this.config["height"];
            this.buildList(false);
            if (this.config["position"] == "over")
            {
                this.stateHandler();
            }
            else
            {
                this.clip.visible = this.config["visible"];
            }
            return;
        }// end function

        private function loaderHandler(event:Event) : void
        {
            var _loc_2:* = Loader(event.target.loader);
            Stretcher.stretch(_loc_2, this.image[0], this.image[1], Stretcher.FILL);
            return;
        }// end function

    }
}
