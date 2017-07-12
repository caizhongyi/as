package com.jeroenwijering.plugins
{
    import com.jeroenwijering.events.*;
    import com.jeroenwijering.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class Dock extends Object implements PluginInterface
    {
        private var buttons:Array;
        public var config:Object;
        private var view:AbstractView;
        private var timeout:Number;
        public var clip:MovieClip;
        private var colors:Object;

        public function Dock() : void
        {
            this.config = {align:"right"};
            this.buttons = new Array();
            return;
        }// end function

        public function initializePlugin(param1:AbstractView) : void
        {
            this.view = param1;
            if (this.view.config["dock"])
            {
                this.view.addControllerListener(ControllerEvent.RESIZE, this.resizeHandler);
                this.view.addModelListener(ModelEvent.STATE, this.stateHandler);
                this.clip.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.moveHandler);
            }
            else
            {
                this.clip.visible = false;
            }
            if (this.view.config["backcolor"] && this.view.config["frontcolor"])
            {
                this.setColorTransforms();
            }
            return;
        }// end function

        private function setColorTransforms() : void
        {
            var _loc_1:* = new ColorTransform();
            _loc_1.color = uint("0x" + this.view.config["backcolor"]);
            var _loc_2:* = new ColorTransform();
            _loc_2.color = uint("0x" + this.view.config["frontcolor"]);
            var _loc_3:* = new ColorTransform();
            if (this.view.config["lightcolor"])
            {
                _loc_3.color = uint("0x" + this.view.config["lightcolor"]);
            }
            else
            {
                _loc_3.color = uint("0x" + this.view.config["backcolor"]);
            }
            this.colors = {back:_loc_2, front:_loc_1, light:_loc_3};
            return;
        }// end function

        public function removeButton(param1:DockButton) : void
        {
            var btn:* = param1;
            var i:Number;
            while (i < this.buttons.length)
            {
                
                if (this.buttons[i] == btn)
                {
                    this.buttons.splice(i, 1);
                }
                i = (i + 1);
            }
            try
            {
                this.clip.removeChild(btn);
            }
            catch (err:Error)
            {
            }
            return;
        }// end function

        private function moveHandler(event:MouseEvent = null) : void
        {
            clearTimeout(this.timeout);
            if (this.view.config["state"] == ModelStates.BUFFERING || this.view.config["state"] == ModelStates.PLAYING)
            {
                this.timeout = setTimeout(this.moveTimeout, 2000);
                if (this.clip.alpha < 1)
                {
                    Animations.fade(this.clip, 1);
                }
            }
            return;
        }// end function

        public function addButton(param1:DisplayObject, param2:String, param3:Function) : DockButton
        {
            var _loc_4:* = new DockButton(param1, param2, param3, this.colors);
            this.clip.addChild(_loc_4);
            this.buttons.push(_loc_4);
            this.resizeHandler();
            return _loc_4;
        }// end function

        private function stateHandler(event:ModelEvent = ) : void
        {
            switch(this.view.config["state"])
            {
                case ModelStates.PLAYING:
                case ModelStates.BUFFERING:
                {
                    this.moveHandler();
                    break;
                }
                default:
                {
                    clearTimeout(this.timeout);
                    Animations.fade(this.clip, 1);
                    break;
                    break;
                }
            }
            return;
        }// end function

        private function resizeHandler(event:ControllerEvent = null) : void
        {
            this.clip.y = this.config["y"];
            if (this.config["align"] == "left")
            {
                this.clip.x = this.config["x"];
            }
            else
            {
                this.clip.x = this.config["x"] + this.config["width"] - this.clip.width;
            }
            var _loc_2:Number = 0;
            while (_loc_2 < this.buttons.length)
            {
                
                this.buttons[_loc_2].y = this.buttons[_loc_2].height * _loc_2;
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        private function moveTimeout() : void
        {
            Animations.fade(this.clip, 0);
            return;
        }// end function

    }
}
