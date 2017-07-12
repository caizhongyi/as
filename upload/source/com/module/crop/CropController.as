package com.module.crop
{
    import com.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.ui.*;

    public class CropController extends Sprite
    {
        private var downX:Number;
        private var downY:Number;
        private var crop:Sprite;
        private var button:Sprite;
        private var button_size:Number = 20;
        private var minSize_:Number = 40;
        private var maxSize_:Number = 300;
        public var image_width:Number = 0;
        public var image_height:Number = 0;
        private var lock:Boolean = false;
        private var stage_:DisplayObject;
        private var width_:Number;
        private var height_:Number;
        private var stageWidth_:Number;
        private var stageHeight_:Number;
        private var dragRectangles:Rectangle;
        private var moveMc:MoveAction;
        public static const ON_CHANGE:String = "on_change";
        public static const ON_MOUSE_RELEASE:String = "on_mouse_release";

        public function CropController(param1:DisplayObject, param2:Number, param3:Number, param4:Number, param5:Number)
        {
            var _loc_6:Number = NaN;
            this.width_ = this.minSize_;
            this.height_ = this.minSize_;
            this.moveMc = new MoveAction();
            this.stage_ = param1;
            this.width_ = param2;
            this.height_ = param3;
            this.stageWidth_ = param4;
            this.stageHeight_ = param5;
            this.crop = new Sprite();
            this.crop.buttonMode = true;
            this.crop.x = this.stageWidth_ / 2 - this.width_ / 2;
            this.crop.y = this.stageHeight_ / 2 - this.height_ / 2;
            this.crop.addEventListener(MouseEvent.MOUSE_DOWN, this.onCropMouseDown);
            this.crop.addEventListener(MouseEvent.MOUSE_OUT, this.out);
            this.crop.addEventListener(MouseEvent.MOUSE_OVER, this.over);
            this.button = new Sprite();
            this.button.buttonMode = true;
            this.button.visible = false;
            _loc_6 = this.button_size;
            this.button.graphics.beginFill(16777215, 0.5);
            this.button.graphics.moveTo(_loc_6, 0);
            this.button.graphics.lineTo(_loc_6, _loc_6);
            this.button.graphics.lineTo(0, _loc_6);
            this.button.graphics.lineTo(_loc_6, 0);
            _loc_6 = this.button_size - 2;
            this.button.graphics.lineStyle(0.1, 8947848, 1);
            this.button.graphics.moveTo(_loc_6, _loc_6 / 3 + 1);
            this.button.graphics.lineTo(_loc_6 / 3 + 1, _loc_6);
            this.button.graphics.moveTo(_loc_6, _loc_6 / 3 * 1.6 + 1);
            this.button.graphics.lineTo(_loc_6 / 3 * 1.6 + 1, _loc_6);
            this.button.graphics.moveTo(_loc_6, _loc_6 / 3 * 2.2 + 1);
            this.button.graphics.lineTo(_loc_6 / 3 * 2.2 + 1, _loc_6);
            this.button.graphics.endFill();
            this.button.graphics.lineStyle(0.1, 0, 1);
            this.button.graphics.moveTo(_loc_6, _loc_6 / 3);
            this.button.graphics.lineTo(_loc_6 / 3, _loc_6);
            this.button.graphics.moveTo(_loc_6, _loc_6 / 3 * 1.6);
            this.button.graphics.lineTo(_loc_6 / 3 * 1.6, _loc_6);
            this.button.graphics.moveTo(_loc_6, _loc_6 / 3 * 2.2);
            this.button.graphics.lineTo(_loc_6 / 3 * 2.2, _loc_6);
            this.button.graphics.endFill();
            this.button.addEventListener(MouseEvent.MOUSE_DOWN, this.onButtonMouseDown);
            this.button.addEventListener(MouseEvent.MOUSE_OUT, this.outBtn);
            this.button.addEventListener(MouseEvent.MOUSE_OVER, this.overBtn);
            this.dragRectangles = new Rectangle(0, 0, this.stageWidth_ - this.width_, this.stageHeight_ - this.height_);
            this.addChild(this.crop);
            this.reDraw();
            return;
        }// end function

        private function out(event:Event) : void
        {
            Main.App.moveMc.visible = false;
            Main.App.moveMc.stopDrag();
            Mouse.show();
            return;
        }// end function

        private function over(event:Event) : void
        {
            Main.App.moveMc.visible = true;
            Main.App.moveMc.startDrag(true);
            Mouse.hide();
            return;
        }// end function

        private function outBtn(event:Event) : void
        {
            Main.App.arr.stopDrag();
            return;
        }// end function

        private function overBtn(event:Event) : void
        {
            Main.App.arr.startDrag(true);
            return;
        }// end function

        private function onCropMouseDown(event:MouseEvent) : void
        {
            this.downX = this.crop.mouseX;
            this.downY = this.crop.mouseY;
            this.stage_.addEventListener(Event.ENTER_FRAME, this.onEnterFrames);
            this.stage_.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUps);
            return;
        }// end function

        private function onEnterFrames(event:Event) : void
        {
            this.crop.x = Math.min(Math.max(this.dragRectangles.x, this.mouseX - this.downX), this.dragRectangles.x + this.dragRectangles.width);
            this.crop.y = Math.min(Math.max(this.dragRectangles.y, this.mouseY - this.downY), this.dragRectangles.y + this.dragRectangles.height);
            this.dispatchEvent(new Event(CropController.ON_CHANGE));
            this.reDraw();
            return;
        }// end function

        private function onMouseUps(event:MouseEvent) : void
        {
            this.stage_.removeEventListener(Event.ENTER_FRAME, this.onEnterFrames);
            this.stage_.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUps);
            this.reDraw();
            this.dispatchEvent(new Event(CropController.ON_MOUSE_RELEASE));
            return;
        }// end function

        private function onButtonMouseDown(event:MouseEvent) : void
        {
            this.downX = this.button.mouseX;
            this.downY = this.button.mouseY;
            this.stage_.addEventListener(Event.ENTER_FRAME, this.onButtonEnterFrame);
            this.stage_.addEventListener(MouseEvent.MOUSE_UP, this.onButtonMouseUp);
            return;
        }// end function

        private function onButtonEnterFrame(event:Event) : void
        {
            var _loc_4:Number = NaN;
            var _loc_2:* = this.mouseX + 5;
            var _loc_3:* = this.mouseY + 5;
            var _loc_5:* = Math.max(_loc_2 - this.crop.x, this.minSize);
            var _loc_6:* = Math.max(_loc_3 - this.crop.y, this.minSize);
            if (this.crop.x + _loc_5 > this.dragRectangles.x + this.image_width)
            {
                _loc_5 = this.dragRectangles.x + this.image_width - this.crop.x;
            }
            if (this.crop.y + _loc_6 > this.dragRectangles.y + this.image_height)
            {
                _loc_6 = this.dragRectangles.y + this.image_height - this.crop.y;
            }
            _loc_5 = Math.min(_loc_5, this.maxSize);
            _loc_6 = Math.min(_loc_6, this.maxSize);
            if (this.lock)
            {
                _loc_4 = Math.min(_loc_5, _loc_6);
                this.width_ = _loc_4;
                this.height_ = _loc_4;
            }
            else
            {
                this.width_ = _loc_5;
                this.height_ = _loc_6;
            }
            this.dispatchEvent(new Event(CropController.ON_CHANGE));
            this.reDraw();
            return;
        }// end function

        private function onButtonMouseUp(event:MouseEvent) : void
        {
            this.stage_.removeEventListener(Event.ENTER_FRAME, this.onButtonEnterFrame);
            this.stage_.removeEventListener(MouseEvent.MOUSE_UP, this.onButtonMouseUp);
            this.dispatchEvent(new Event(CropController.ON_MOUSE_RELEASE));
            return;
        }// end function

        public function set dragRectangle(param1:Rectangle) : void
        {
            this.dragRectangles = param1;
            this.reDraw();
            return;
        }// end function

        public function set minSize(param1:Number) : void
        {
            this.minSize_ = param1;
            return;
        }// end function

        public function set maxSize(param1:Number) : void
        {
            if (param1 >= this.stageWidth_ || param1 >= this.stageHeight_)
            {
                param1 = Math.min(this.stageWidth_, this.stageHeight_) - 1;
            }
            this.maxSize_ = param1;
            return;
        }// end function

        public function get minSize() : Number
        {
            return this.minSize_;
        }// end function

        public function get maxSize() : Number
        {
            return this.maxSize_;
        }// end function

        override public function set x(param1:Number) : void
        {
            param1 = Math.min(param1, this.stageWidth_ - this.width_);
            param1 = Math.max(param1, 0);
            this.crop.x = param1;
            this.reDraw();
            return;
        }// end function

        override public function set y(param1:Number) : void
        {
            param1 = Math.min(param1, this.stageHeight_ - this.height_);
            param1 = Math.max(param1, 0);
            this.crop.y = param1;
            this.reDraw();
            return;
        }// end function

        override public function set width(param1:Number) : void
        {
            param1 = Math.min(param1, this.stageWidth_);
            param1 = Math.max(param1, this.minSize_);
            this.width_ = param1;
            this.reDraw();
            return;
        }// end function

        override public function set height(param1:Number) : void
        {
            param1 = Math.min(param1, this.stageHeight_);
            param1 = Math.max(param1, this.minSize_);
            this.height_ = param1;
            this.reDraw();
            return;
        }// end function

        override public function get x() : Number
        {
            return this.crop.x;
        }// end function

        override public function get y() : Number
        {
            return this.crop.y;
        }// end function

        override public function get width() : Number
        {
            return this.width_;
        }// end function

        override public function get height() : Number
        {
            return this.height_;
        }// end function

        private function reDraw() : void
        {
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            this.graphics.clear();
            this.graphics.beginFill(0, 0.8);
            this.graphics.drawRect(0, 0, this.crop.x, this.stageHeight_);
            this.graphics.drawRect(this.crop.x + this.width_, 0, this.stageWidth_ - this.crop.x - this.width_, this.stageHeight_);
            this.graphics.drawRect(this.crop.x, 0, this.width_, this.crop.y);
            this.graphics.drawRect(this.crop.x, this.crop.y + this.height_, this.width_, this.stageHeight_ - this.crop.y - this.height_);
            this.crop.graphics.clear();
            this.crop.graphics.beginFill(16777215, 0);
            this.crop.graphics.drawRect(0, 0, this.width_, this.height_);
            this.crop.graphics.lineStyle(0.1, 16777215, 1, true, LineScaleMode.NONE, CapsStyle.NONE);
            var _loc_1:Number = 5;
            var _loc_2:* = Math.ceil(this.width_ / _loc_1);
            var _loc_3:* = Math.ceil(this.height_ / _loc_1);
            _loc_6 = this.width_;
            _loc_7 = this.height_;
            var _loc_8:uint = 0;
            while (_loc_8 < _loc_2)
            {
                
                _loc_4 = _loc_8 * _loc_1;
                _loc_5 = Math.min(_loc_4 + _loc_1 / 1, _loc_6);
                this.crop.graphics.moveTo(_loc_4, 0);
                this.crop.graphics.lineTo(_loc_5, 0);
                _loc_8 = _loc_8 + 1;
            }
            var _loc_9:uint = 0;
            while (_loc_9 < _loc_2)
            {
                
                _loc_4 = _loc_9 * _loc_1;
                _loc_5 = Math.min(_loc_4 + _loc_1 / 1, _loc_6);
                this.crop.graphics.moveTo(_loc_4, _loc_7);
                this.crop.graphics.lineTo(_loc_5, _loc_7);
                _loc_9 = _loc_9 + 1;
            }
            var _loc_10:uint = 0;
            while (_loc_10 < _loc_3)
            {
                
                _loc_4 = _loc_10 * _loc_1;
                _loc_5 = Math.min(_loc_4 + _loc_1 / 1, _loc_7);
                this.crop.graphics.moveTo(0, _loc_4);
                this.crop.graphics.lineTo(0, _loc_5);
                _loc_10 = _loc_10 + 1;
            }
            var _loc_11:uint = 0;
            while (_loc_11 < _loc_3)
            {
                
                _loc_4 = _loc_11 * _loc_1;
                var _loc_12:* = _loc_4 + _loc_1 / 1;
                _loc_5 = _loc_4 + _loc_1 / 1;
                _loc_5 = Math.min(_loc_12, _loc_7);
                this.crop.graphics.moveTo(_loc_6, _loc_4);
                this.crop.graphics.lineTo(_loc_6, _loc_5);
                _loc_11 = _loc_11 + 1;
            }
            this.crop.graphics.endFill();
            this.button.x = this.crop.x + this.width_ - this.button_size - 1;
            this.button.y = this.crop.y + this.height_ - this.button_size - 1;
            return;
        }// end function

    }
}
