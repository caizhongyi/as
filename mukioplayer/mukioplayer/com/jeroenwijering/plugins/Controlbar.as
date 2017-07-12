package com.jeroenwijering.plugins
{
    import com.jeroenwijering.events.*;
    import com.jeroenwijering.utils.*;
    import flash.accessibility.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.ui.*;
    import flash.utils.*;

    public class Controlbar extends Object implements PluginInterface
    {
        private var scrubber:MovieClip;
        public var config:Object;
        public var clip:MovieClip;
        private var light:ColorTransform;
        private var SLIDERS:Object;
        private var BUTTONS:Object;
        private var view:AbstractView;
        private var clonee:MovieClip;
        private var front:ColorTransform;
        private var stacker:Stacker;
        private var blocking:Boolean;
        private var hiding:Number;

        public function Controlbar() : void
        {
            this.config = {};
            this.BUTTONS = {playButton:"PLAY", pauseButton:"PLAY", prevButton:"PREV", nextButton:"NEXT", linkButton:"LINK", fullscreenButton:"FULLSCREEN", normalscreenButton:"FULLSCREEN", muteButton:"MUTE", unmuteButton:"MUTE"};
            this.SLIDERS = {timeSlider:"SEEK", volumeSlider:"VOLUME"};
            return;
        }// end function

        private function setColors() : void
        {
            var clr:ColorTransform;
            var btn:String;
            var sld:String;
            if (this.view.config["backcolor"] && this.clip["playButton"].icon)
            {
                clr = new ColorTransform();
                clr.color = uint("0x" + this.view.config["backcolor"].substr(-6));
                this.clip.back.transform.colorTransform = clr;
            }
            if (this.view.config["frontcolor"])
            {
                try
                {
                    this.front = new ColorTransform();
                    this.front.color = uint("0x" + this.view.config["frontcolor"].substr(-6));
                    var _loc_2:int = 0;
                    var _loc_3:* = this.BUTTONS;
                    while (_loc_3 in _loc_2)
                    {
                        
                        btn = _loc_3[_loc_2];
                        if (this.clip[btn])
                        {
                            this.clip[btn]["icon"].transform.colorTransform = this.front;
                        }
                    }
                    var _loc_2:int = 0;
                    var _loc_3:* = this.SLIDERS;
                    while (_loc_3 in _loc_2)
                    {
                        
                        sld = _loc_3[_loc_2];
                        if (this.clip[sld])
                        {
                            this.clip[sld]["icon"].transform.colorTransform = this.front;
                            this.clip[sld]["mark"].transform.colorTransform = this.front;
                            this.clip[sld]["rail"].transform.colorTransform = this.front;
                        }
                    }
                    this.clip.elapsedText.textColor = this.front.color;
                    this.clip.totalText.textColor = this.front.color;
                }
                catch (err:Error)
                {
                }
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
            if (this.light)
            {
                try
                {
                    this.clip["timeSlider"]["done"].transform.colorTransform = this.light;
                    this.clip["volumeSlider"]["mark"].transform.colorTransform = this.light;
                }
                catch (err:Error)
                {
                }
            }
            return;
        }// end function

        private function volumeHandler(event:ControllerEvent = null) : void
        {
            var vsl:MovieClip;
            var evt:* = event;
            try
            {
                vsl = this.clip.volumeSlider;
                vsl.mark.width = this.view.config["volume"] * (vsl.rail.width - vsl.icon.width / 2) / 100;
                vsl.icon.x = vsl.mark.x + this.view.config["volume"] * (vsl.rail.width - vsl.icon.width) / 100;
            }
            catch (err:Error)
            {
            }
            return;
        }// end function

        private function loadedHandler(event:ModelEvent = null) : void
        {
            var wid:Number;
            var icw:Number;
            var evt:* = event;
            var pc1:Number;
            if (evt && evt.data.total > 0)
            {
                pc1 = evt.data.loaded / evt.data.total;
            }
            var pc2:Number;
            if (evt && evt.data.offset)
            {
                pc2 = evt.data.offset / evt.data.total;
            }
            try
            {
                wid = this.clip.timeSlider.rail.width;
                this.clip.timeSlider.mark.x = pc2 * wid;
                this.clip.timeSlider.mark.width = pc1 * wid;
                icw = this.clip.timeSlider.icon.x + this.clip.timeSlider.icon.width;
            }
            catch (err:Error)
            {
            }
            return;
        }// end function

        private function setButtons() : void
        {
            var _loc_1:String = null;
            var _loc_2:String = null;
            for (_loc_1 in this.BUTTONS)
            {
                
                if (this.clip[_loc_1])
                {
                    this.clip[_loc_1].mouseChildren = false;
                    this.clip[_loc_1].buttonMode = true;
                    this.clip[_loc_1].addEventListener(MouseEvent.CLICK, this.clickHandler);
                    this.clip[_loc_1].addEventListener(MouseEvent.MOUSE_OVER, this.overHandler);
                    this.clip[_loc_1].addEventListener(MouseEvent.MOUSE_OUT, this.outHandler);
                }
            }
            for (_loc_2 in this.SLIDERS)
            {
                
                if (this.clip[_loc_2])
                {
                    this.clip[_loc_2].mouseChildren = false;
                    this.clip[_loc_2].buttonMode = true;
                    this.clip[_loc_2].addEventListener(MouseEvent.MOUSE_DOWN, this.downHandler);
                    this.clip[_loc_2].addEventListener(MouseEvent.MOUSE_OVER, this.overHandler);
                    this.clip[_loc_2].addEventListener(MouseEvent.MOUSE_OUT, this.outHandler);
                }
            }
            return;
        }// end function

        private function downHandler(event:MouseEvent) : void
        {
            var _loc_2:Rectangle = null;
            this.scrubber = MovieClip(event.target);
            if (this.blocking != true || this.scrubber.name == "volumeSlider")
            {
                _loc_2 = new Rectangle(this.scrubber.rail.x, this.scrubber.icon.y, this.scrubber.rail.width - this.scrubber.icon.width, 0);
                this.scrubber.icon.startDrag(true, _loc_2);
                this.clip.stage.addEventListener(MouseEvent.MOUSE_UP, this.upHandler);
            }
            else
            {
                this.scrubber = undefined;
            }
            return;
        }// end function

        public function block(param1:Boolean) : void
        {
            this.blocking = param1;
            this.timeHandler();
            return;
        }// end function

        private function fixTime() : void
        {
            var scp:Number;
            try
            {
                scp = this.clip.timeSlider.scaleX;
                this.clip.timeSlider.scaleX = 1;
                this.clip.timeSlider.icon.x = scp * this.clip.timeSlider.icon.x;
                this.clip.timeSlider.mark.x = scp * this.clip.timeSlider.mark.x;
                this.clip.timeSlider.mark.width = scp * this.clip.timeSlider.mark.width;
                this.clip.timeSlider.rail.width = scp * this.clip.timeSlider.rail.width;
                this.clip.timeSlider.done.x = scp * this.clip.timeSlider.done.x;
                this.clip.timeSlider.done.width = scp * this.clip.timeSlider.done.width;
            }
            catch (err:Error)
            {
            }
            return;
        }// end function

        private function stateHandler(event:ModelEvent = ) : void
        {
            var dps:String;
            var evt:* = event;
            clearTimeout(this.hiding);
            this.view.skin.removeEventListener(MouseEvent.MOUSE_MOVE, this.moveHandler);
            try
            {
                dps = this.clip.stage["displayState"];
            }
            catch (err:Error)
            {
            }
            switch(this.view.config["state"])
            {
                case ModelStates.PLAYING:
                case ModelStates.BUFFERING:
                {
                    try
                    {
                        this.clip.playButton.visible = false;
                        this.clip.pauseButton.visible = true;
                    }
                    catch (err:Error)
                    {
                    }
                    if (this.config["position"] == "over" || dps == "fullScreen" && this.config["position"] != "none")
                    {
                        this.hiding = setTimeout(this.moveTimeout, 2000);
                        this.view.skin.addEventListener(MouseEvent.MOUSE_MOVE, this.moveHandler);
                    }
                    else
                    {
                        Animations.fade(this.clip, 1);
                    }
                    break;
                }
                default:
                {
                    try
                    {
                        this.clip.playButton.visible = true;
                        this.clip.pauseButton.visible = false;
                    }
                    catch (err:Error)
                    {
                    }
                    if (this.config["position"] == "over" || dps == "fullScreen")
                    {
                        Mouse.show();
                        Animations.fade(this.clip, 1);
                    }
                    break;
                }
            }
            return;
        }// end function

        private function outHandler(event:MouseEvent) : void
        {
            if (this.front && event.target["icon"])
            {
                event.target["icon"].transform.colorTransform = this.front;
            }
            else
            {
                event.target.gotoAndPlay("out");
            }
            return;
        }// end function

        private function overHandler(event:MouseEvent) : void
        {
            if (this.front && event.target["icon"])
            {
                event.target["icon"].transform.colorTransform = this.light;
            }
            else
            {
                event.target.gotoAndPlay("over");
            }
            return;
        }// end function

        private function moveTimeout() : void
        {
            Animations.fade(this.clip, 0);
            Mouse.hide();
            return;
        }// end function

        private function clickHandler(event:MouseEvent) : void
        {
            var _loc_2:* = this.BUTTONS[event.target.name];
            if (this.blocking != true || _loc_2 == "FULLSCREEN" || _loc_2 == "MUTE")
            {
                this.view.sendEvent(_loc_2);
            }
            return;
        }// end function

        public function initializePlugin(param1:AbstractView) : void
        {
            this.view = param1;
            this.view.addControllerListener(ControllerEvent.RESIZE, this.resizeHandler);
            this.view.addModelListener(ModelEvent.LOADED, this.loadedHandler);
            this.view.addModelListener(ModelEvent.STATE, this.stateHandler);
            this.view.addModelListener(ModelEvent.TIME, this.timeHandler);
            this.view.addControllerListener(ControllerEvent.PLAYLIST, this.itemHandler);
            this.view.addControllerListener(ControllerEvent.ITEM, this.itemHandler);
            this.view.addControllerListener(ControllerEvent.MUTE, this.muteHandler);
            this.view.addControllerListener(ControllerEvent.VOLUME, this.volumeHandler);
            this.stacker = new Stacker(this.clip);
            this.setButtons();
            this.setColors();
            this.itemHandler();
            this.loadedHandler();
            this.muteHandler();
            this.stateHandler();
            this.timeHandler();
            this.volumeHandler();
            return;
        }// end function

        private function upHandler(event:MouseEvent) : void
        {
            var _loc_2:Number = 0;
            this.clip.stage.removeEventListener(MouseEvent.MOUSE_UP, this.upHandler);
            this.scrubber.icon.stopDrag();
            if (this.scrubber.name == "timeSlider" && this.view.playlist)
            {
                _loc_2 = this.view.playlist[this.view.config["item"]]["duration"];
            }
            else if (this.scrubber.name == "volumeSlider")
            {
                _loc_2 = 100;
            }
            var _loc_3:* = (this.scrubber.icon.x - this.scrubber.rail.x) / (this.scrubber.rail.width - this.scrubber.icon.width) * _loc_2;
            this.view.sendEvent(this.SLIDERS[this.scrubber.name], Math.round(_loc_3));
            this.scrubber = undefined;
            return;
        }// end function

        private function resizeHandler(event:ControllerEvent = null) : void
        {
            var evt:* = event;
            var wid:* = this.config["width"];
            this.clip.x = this.config["x"];
            this.clip.y = this.config["y"];
            this.clip.visible = this.config["visible"];
            this.clip.back.alpha = this.clip.stage["displayState"] == "fullScreen" ? (0.65) : (1);
            if (this.config["position"] == "over" || this.view.config["fullscreen"] == true)
            {
                this.clip.x = this.config["x"] + this.config["margin"];
                this.clip.y = this.config["y"] + this.config["height"] - this.config["margin"] - this.config["size"];
                wid = this.config["width"] - 2 * this.config["margin"];
            }
            try
            {
                this.clip.fullscreenButton.visible = false;
                this.clip.normalscreenButton.visible = false;
                if (this.clip.stage["displayState"] && this.view.config["height"] > 40)
                {
                    trace("view.config[\'fullscreen\'] : " + this.view.config["fullscreen"]);
                    if (this.view.config["fullscreen"])
                    {
                        this.clip.fullscreenButton.visible = false;
                        this.clip.normalscreenButton.visible = true;
                    }
                    else
                    {
                        this.clip.fullscreenButton.visible = true;
                        this.clip.normalscreenButton.visible = false;
                    }
                }
            }
            catch (err:Error)
            {
            }
            this.stacker.rearrange(wid);
            this.stateHandler();
            this.fixTime();
            Mouse.show();
            return;
        }// end function

        private function itemHandler(event:ControllerEvent = null) : void
        {
            var evt:* = event;
            try
            {
                if (this.view.playlist && this.view.playlist.length > 1)
                {
                    var _loc_3:Boolean = true;
                    this.clip.nextButton.visible = true;
                    this.clip.prevButton.visible = _loc_3;
                }
                else
                {
                    var _loc_3:Boolean = false;
                    this.clip.nextButton.visible = false;
                    this.clip.prevButton.visible = _loc_3;
                }
            }
            catch (err:Error)
            {
                try
                {
                }
                if (this.view.playlist && this.view.playlist[this.view.config["item"]]["link"] && !this.view.getPlugin("sharing"))
                {
                    this.clip.linkButton.visible = true;
                }
                else
                {
                    this.clip.linkButton.visible = false;
                }
            }
            catch (err:Error)
            {
            }
            this.timeHandler();
            this.stacker.rearrange();
            this.fixTime();
            this.loadedHandler(new ModelEvent(ModelEvent.LOADED, {loaded:0, total:0}));
            return;
        }// end function

        private function muteHandler(event:ControllerEvent = null) : void
        {
            var evt:* = event;
            if (this.view.config["mute"] == true)
            {
                try
                {
                    this.clip.muteButton.visible = false;
                    this.clip.unmuteButton.visible = true;
                }
                catch (err:Error)
                {
                    try
                    {
                    }
                    this.clip.volumeSlider.mark.visible = false;
                    this.clip.volumeSlider.icon.x = this.clip.volumeSlider.rail.x;
                }
                catch (err:Error)
                {
                }
            }
            else
            {
                try
                {
                    this.clip.muteButton.visible = true;
                    this.clip.unmuteButton.visible = false;
                }
                catch (err:Error)
                {
                    try
                    {
                    }
                    this.clip.volumeSlider.mark.visible = true;
                    this.volumeHandler();
                }
                catch (err:Error)
                {
                }
            }
            return;
        }// end function

        private function moveHandler(event:MouseEvent = null) : void
        {
            if (this.clip.alpha == 0)
            {
                Animations.fade(this.clip, 1);
            }
            clearTimeout(this.hiding);
            this.hiding = setTimeout(this.moveTimeout, 2000);
            Mouse.show();
            return;
        }// end function

        public function addButton(param1:DisplayObject, param2:String, param3:Function)
        {
            var _loc_4:* = undefined;
            var _loc_5:AccessibilityProperties = null;
            var _loc_6:Number = NaN;
            if (this.clip["linkButton"] && this.clip["linkButton"].back)
            {
                _loc_4 = Draw.clone(this.clip["linkButton"]);
                _loc_4.name = param2 + "Button";
                _loc_4.visible = true;
                _loc_4.tabEnabled = true;
                _loc_4.tabIndex = 6;
                _loc_5 = new AccessibilityProperties();
                _loc_5.name = param2 + "Button";
                _loc_4.accessibilityProperties = _loc_5;
                this.clip.addChild(_loc_4);
                _loc_6 = Math.round((_loc_4.height - param1.height) / 2);
                Draw.clear(_loc_4.icon);
                _loc_4.icon.addChild(param1);
                var _loc_7:int = 0;
                param1.y = 0;
                param1.x = _loc_7;
                var _loc_7:* = _loc_6;
                _loc_4.icon.y = _loc_6;
                _loc_4.icon.x = _loc_7;
                _loc_4.back.width = param1.width + 2 * _loc_6;
                _loc_4.buttonMode = true;
                _loc_4.mouseChildren = false;
                _loc_4.addEventListener(MouseEvent.CLICK, param3);
                if (this.front)
                {
                    _loc_4.icon.transform.colorTransform = this.front;
                    _loc_4.addEventListener(MouseEvent.MOUSE_OVER, this.overHandler);
                    _loc_4.addEventListener(MouseEvent.MOUSE_OUT, this.outHandler);
                }
                this.stacker.insert(_loc_4, this.clip["linkButton"]);
                return _loc_4;
            }
            return;
        }// end function

        private function timeHandler(event:ModelEvent = null) : void
        {
            var tsl:MovieClip;
            var xps:Number;
            var evt:* = event;
            var dur:Number;
            var pos:Number;
            if (evt)
            {
                dur = evt.data.duration;
                pos = evt.data.position;
            }
            else if (this.view.playlist)
            {
                dur = this.view.playlist[this.view.config["item"]]["duration"];
                pos;
            }
            var pct:* = pos / dur;
            if (isNaN(pct))
            {
                pct;
            }
            try
            {
                this.clip.elapsedText.text = Strings.digits(pos);
                this.clip.totalText.text = Strings.digits(dur);
            }
            catch (err:Error)
            {
                try
                {
                }
                tsl = this.clip.timeSlider;
                xps = Math.round(pct * (tsl.rail.width - tsl.icon.width));
                if (dur > 0)
                {
                    this.clip.timeSlider.icon.visible = true;
                    this.clip.timeSlider.mark.visible = true;
                    if (!this.scrubber)
                    {
                        this.clip.timeSlider.icon.x = xps;
                        this.clip.timeSlider.done.width = xps;
                    }
                    this.clip.timeSlider.done.visible = true;
                }
                else
                {
                    this.clip.timeSlider.icon.visible = false;
                    this.clip.timeSlider.mark.visible = false;
                    this.clip.timeSlider.done.visible = false;
                }
            }
            catch (err:Error)
            {
            }
            return;
        }// end function

    }
}
