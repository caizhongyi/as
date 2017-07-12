package com.module.crop
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class Crop extends Sprite
    {
        private var stages:DisplayObject;
        private var _width:Number;
        private var _height:Number;
        public var minScale:Number = 0.01;
        public var maxScale:Number = 6;
        private var _controller:CropController;
        private var _mask:Sprite;
        private var _container:Sprite;
        private var _container_lev2:Sprite;
        private var _image:DisplayObject;
        public static const ON_MOUSE_RELEASE:String = "onMouseRelease";

        public function Crop(param1:DisplayObject, param2:Number, param3:Number)
        {
            this.stages = param1;
            this._width = param2;
            this._height = param3;
            this._controller = new CropController(this.stages, 180, 180, this._width, this._height);
            this._controller.addEventListener(CropController.ON_CHANGE, this.onCropChange);
            this._mask = new Sprite();
            this.drawMask(this._width, this._height);
            this._container = new Sprite();
            this._container_lev2 = new Sprite();
            this._container.mask = this._mask;
            this._container.addChild(this._container_lev2);
            this.addChild(this._container);
            this.addChild(this._mask);
            this.addChild(this._controller);
            this.addEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
            this._controller.addEventListener(CropController.ON_MOUSE_RELEASE, this.onMouseRelease);
            this._controller.addEventListener(CropController.ON_CHANGE, this.onMouseRelease);
            return;
        }// end function

        private function mouseMove(event:MouseEvent) : void
        {
            event.updateAfterEvent();
            return;
        }// end function

        private function onMouseRelease(event:Event) : void
        {
            this.dispatchEvent(new Event(Crop.ON_MOUSE_RELEASE));
            return;
        }// end function

        private function onCropChange(event:Event) : void
        {
            this.refresh();
            return;
        }// end function

        private function refresh() : void
        {
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            if (this._image.width < this._image.height)
            {
                this._image.width = Math.max(this._image.width, this._controller.width);
                this._image.scaleY = this._image.scaleX;
            }
            else if (this._image.height < this._image.width)
            {
                this._image.height = Math.max(this._image.height, this._controller.height);
                this._image.scaleX = this._image.scaleY;
            }
            else
            {
                this._image.width = Math.max(this._image.width, this._controller.width);
                this._image.height = Math.max(this._image.height, this._controller.height);
            }
            if (this._image.width < this._width)
            {
                this._image.x = this._width / 2 - this._image.width / 2;
            }
            if (this._image.height < this._height)
            {
                this._image.y = this._height / 2 - this._image.height / 2;
            }
            if (this._image.width > this._width)
            {
                _loc_1 = (this._width - this._controller.width) / this._controller.x;
                this._image.x = this._width / _loc_1 - this._image.width / _loc_1;
            }
            if (this._image.height > this._height)
            {
                _loc_1 = (this._height - this._controller.height) / this._controller.y;
                this._image.y = this._height / _loc_1 - this._image.height / _loc_1;
            }
            if (this._image.width < this._width)
            {
                _loc_2 = this._image.x;
                _loc_4 = this._image.width;
                if (this._controller.x < this._image.x)
                {
                    this._controller.x = Math.max(this._controller.x, _loc_2);
                }
                else
                {
                    this._controller.x = Math.min(this._controller.x, this._image.x + this._image.width - this._controller.width);
                }
            }
            else
            {
                _loc_2 = 0;
                _loc_4 = this._width;
            }
            if (this._image.height < this._height)
            {
                _loc_3 = this._image.y;
                _loc_5 = this._image.height;
                if (this._controller.y < this._image.y)
                {
                    this._controller.y = Math.max(this._controller.y, _loc_3);
                }
                else
                {
                    this._controller.y = Math.min(this._controller.y, this._image.y + this._image.height - this._controller.height);
                }
            }
            else
            {
                _loc_3 = 0;
                _loc_5 = this._height;
            }
            if (this._controller.height > this._image.height)
            {
                this._controller.height = this._image.height;
                this._controller.y = this._image.y;
            }
            if (this._controller.width > this._image.width)
            {
                this._controller.width = this._image.width;
                this._controller.x = this._image.x;
            }
            this._controller.image_width = _loc_4;
            this._controller.image_height = _loc_5;
            this._controller.dragRectangle = new Rectangle(_loc_2, _loc_3, _loc_4 - this._controller.width, _loc_5 - this._controller.height);
            return;
        }// end function

        private function onMouseWheel(event:MouseEvent) : void
        {
            var _loc_2:* = this._image.scaleX + event.delta * 0.01;
            this.scale = _loc_2;
            this.refresh();
            this.dispatchEvent(new Event(Crop.ON_MOUSE_RELEASE));
            if (this.scale > 2)
            {
                this.scale = 2;
            }
            return;
        }// end function

        public function addImage(param1:DisplayObject) : void
        {
            var _loc_2:* = this._container_lev2.numChildren;
            var _loc_3:uint = 0;
            while (_loc_3 < _loc_2)
            {
                
                this._container_lev2.removeChildAt(0);
                _loc_3 = _loc_3 + 1;
            }
            this._image = param1;
            this._container_lev2.addChild(this._image);
            var _loc_4:* = this.getImageScale(this._image, this._width, this._height);
            var _loc_5:* = _loc_4;
            this._image.scaleY = _loc_4;
            this._image.scaleX = _loc_5;
            this._image.x = this._width / 2 - this._image.width / 2;
            this._image.y = this._height / 2 - this._image.height / 2;
            this.refresh();
            return;
        }// end function

        public function set minSize(param1:Number) : void
        {
            this._controller.minSize = param1;
            return;
        }// end function

        public function set maxSize(param1:Number) : void
        {
            this._controller.maxSize = param1;
            return;
        }// end function

        public function get cropImage() : BitmapData
        {
            var _loc_1:* = new BitmapData(this._width, this._height, true, 0);
            _loc_1.draw(this._container_lev2);
            var _loc_2:* = new BitmapData(int(this._controller.width), int(this._controller.height), true, 0);
            var _loc_3:* = new Matrix();
            _loc_3.translate(int(-this._controller.x), int(-this._controller.y));
            _loc_2.draw(_loc_1, _loc_3);
            return _loc_2;
        }// end function

        private function getImageScale(param1:DisplayObject, param2:Number, param3:Number) : Number
        {
            var _loc_4:* = param1.width;
            var _loc_5:* = param1.height;
            if (_loc_4 < param2 && _loc_5 < param3)
            {
                return 1;
            }
            param1.width = param2;
            param1.height = param3;
            var _loc_6:* = Math.min(param1.scaleX, param1.scaleY);
            _loc_6 = Math.min(_loc_6, 1);
            param1.width = _loc_4;
            param1.height = _loc_5;
            return _loc_6;
        }// end function

        public function drawMask(param1:Number, param2:Number) : void
        {
            this._mask.graphics.beginFill(16777215, 0.1);
            this._mask.graphics.drawRect(0, 0, param1, param2);
            this._mask.graphics.endFill();
            return;
        }// end function

        public function get scale() : Number
        {
            return this._image.scaleX;
        }// end function

        public function set scale(param1:Number) : void
        {
            var _loc_2:* = Math.max(Math.min(param1, this.maxScale), this.minScale);
            if (_loc_2 >= 1)
            {
                _loc_2 = 1;
            }
            var _loc_3:* = _loc_2;
            this._image.scaleY = _loc_2;
            this._image.scaleX = _loc_3;
            if (this._image.width > 2000)
            {
                this._image.width = 2000;
                this._image.scaleY = this._image.scaleX;
            }
            if (this._image.height > 2000)
            {
                this._image.height = 2000;
                this._image.scaleX = this._image.scaleY;
            }
            this.refresh();
            this.dispatchEvent(new Event("onMouseWheel"));
            return;
        }// end function

        override public function get width() : Number
        {
            return this._width;
        }// end function

        override public function get height() : Number
        {
            return this._height;
        }// end function

    }
}
