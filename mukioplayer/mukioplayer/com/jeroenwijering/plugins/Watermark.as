package com.jeroenwijering.plugins
{
    import com.jeroenwijering.events.*;
    import fl.transitions.*;
    import fl.transitions.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class Watermark extends MovieClip implements PluginInterface
    {
        private var _config:Object;
        public var config:Object;
        private var view:AbstractView;
        private var timeout:uint;
        public var clip:MovieClip;
        private var loader:Loader;
        private var configurable:Boolean;

        public function Watermark(param1:Boolean = false) : void
        {
            this.config = {};
            this._config = {file:undefined, link:undefined, margin:10, out:0.5, over:1, state:false, timeout:3};
            this.configurable = param1;
            return;
        }// end function

        public function initializePlugin(param1:AbstractView) : void
        {
            var _loc_2:String = null;
            this.view = param1;
            this.view.addModelListener(ModelEvent.STATE, this.stateHandler);
            this.view.addControllerListener(ControllerEvent.RESIZE, this.resizeHandler);
            if (this.configurable)
            {
                for (_loc_2 in this.config)
                {
                    
                    this._config[_loc_2] = this.config[_loc_2];
                }
            }
            this.clip.visible = false;
            this.clip.alpha = this._config["out"];
            this.clip.buttonMode = true;
            this.clip.addEventListener(MouseEvent.CLICK, this.clickHandler);
            this.clip.addEventListener(MouseEvent.MOUSE_OVER, this.overHandler);
            this.clip.addEventListener(MouseEvent.MOUSE_OUT, this.outHandler);
            if (!this.configurable)
            {
                this.clip.addChild(this);
                this.resizeHandler();
            }
            else if (this._config["file"])
            {
                this.loader = new Loader();
                this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loaderHandler);
                this.loader.load(new URLRequest(this._config["file"]));
            }
            return;
        }// end function

        private function outHandler(event:MouseEvent) : void
        {
            this.clip.alpha = this._config["out"];
            return;
        }// end function

        private function show() : void
        {
            if (!this._config["state"])
            {
                this._config["state"] = true;
                TransitionManager.start(this.clip, {type:Fade, direction:Transition.IN, duration:0.3, easing:Regular.easeIn});
                this.resizeHandler();
            }
            this.timeout = setTimeout(this.hide, this._config["timeout"] * 1000);
            this.clip.mouseEnabled = true;
            return;
        }// end function

        private function clickHandler(event:MouseEvent) : void
        {
            this.view.sendEvent(ViewEvent.PLAY, false);
            var _loc_2:* = this.view.config["aboutlink"];
            if (this._config["link"])
            {
                _loc_2 = this._config["link"];
            }
            navigateToURL(new URLRequest(_loc_2));
            return;
        }// end function

        private function overHandler(event:MouseEvent) : void
        {
            this.clip.alpha = this._config["over"];
            return;
        }// end function

        private function loaderHandler(event:Event) : void
        {
            this.clip.addChild(this.loader);
            this.resizeHandler();
            return;
        }// end function

        private function hide() : void
        {
            this._config["state"] = false;
            this.clip.mouseEnabled = false;
            TransitionManager.start(this.clip, {type:Fade, direction:Transition.OUT, duration:0.3, easing:Regular.easeIn});
            return;
        }// end function

        private function resizeHandler(event:ControllerEvent = null) : void
        {
            this.clip.x = this.config["x"] + this.view.config["width"] - this.clip.width - this._config["margin"];
            this.clip.y = this.config["y"] + this.config["height"] - this.clip.height - this._config["margin"];
            return;
        }// end function

        private function stateHandler(event:ModelEvent) : void
        {
            switch(event.data.newstate)
            {
                case ModelStates.BUFFERING:
                {
                    clearTimeout(this.timeout);
                    this.show();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

    }
}
