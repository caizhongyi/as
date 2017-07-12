package org.libspark.betweenas3.core.updaters.display
{
    import flash.display.*;
    import flash.filters.*;
    import org.libspark.betweenas3.core.updaters.*;
    import org.libspark.betweenas3.core.utils.*;

    public class DisplayObjectUpdater extends AbstractUpdater
    {
        protected var _flags:uint = 0;
        protected var _destination:DisplayObjectParameter;
        protected var _target:DisplayObject = null;
        protected var _source:DisplayObjectParameter;
        public static const TARGET_PROPERTIES:Array = ["x", "y", "z", "scaleX", "scaleY", "scaleZ", "rotation", "rotationX", "rotationY", "rotationZ", "alpha", "width", "height", "_bevelFilter", "_blurFilter", "_colorMatrixFilter", "_convolutionFilter", "_displacementMapFilter", "_dropShadowFilter", "_glowFilter", "_gradientBevelFilter", "_gradientGlowFilter", "_shaderFilter"];

        public function DisplayObjectUpdater()
        {
            this._source = new DisplayObjectParameter();
            this._destination = new DisplayObjectParameter();
            return;
        }// end function

        override public function setObject(param1:String, param2:Object) : void
        {
            if (param1 == "_blurFilter")
            {
                this.setFilterByClass(param2 as BitmapFilter, BlurFilter);
                return;
            }
            if (param1 == "_glowFilter")
            {
                this.setFilterByClass(param2 as BitmapFilter, GlowFilter);
                return;
            }
            if (param1 == "_dropShadowFilter")
            {
                this.setFilterByClass(param2 as BitmapFilter, DropShadowFilter);
                return;
            }
            if (param1 == "_colorMatrixFilter")
            {
                this.setFilterByClass(param2 as BitmapFilter, ColorMatrixFilter);
                return;
            }
            if (param1 == "_bevelFilter")
            {
                this.setFilterByClass(param2 as BitmapFilter, BevelFilter);
                return;
            }
            if (param1 == "_gradientGlowFilter")
            {
                this.setFilterByClass(param2 as BitmapFilter, GradientGlowFilter);
                return;
            }
            if (param1 == "_gradientBevelFilter")
            {
                this.setFilterByClass(param2 as BitmapFilter, GradientBevelFilter);
                return;
            }
            if (param1 == "_convolutionFilter")
            {
                this.setFilterByClass(param2 as BitmapFilter, ConvolutionFilter);
                return;
            }
            if (param1 == "_displacementMapFilter")
            {
                this.setFilterByClass(param2 as BitmapFilter, DisplacementMapFilter);
                return;
            }
            if (param1 == "_shaderFilter")
            {
                this.setFilterByClass(param2 as BitmapFilter, ShaderFilter);
                return;
            }
            return;
        }// end function

        override public function setDestinationValue(param1:String, param2:Number, param3:Boolean = false) : void
        {
            if (param1 == "x")
            {
                this._flags = this._flags | 1;
                this._destination.relativeFlags = this._destination.relativeFlags | (param3 ? (1) : (0));
                this._destination.x = param2;
            }
            else if (param1 == "y")
            {
                this._flags = this._flags | 2;
                this._destination.relativeFlags = this._destination.relativeFlags | (param3 ? (2) : (0));
                this._destination.y = param2;
            }
            else if (param1 == "z")
            {
                this._flags = this._flags | 4;
                this._destination.relativeFlags = this._destination.relativeFlags | (param3 ? (4) : (0));
                this._destination.z = param2;
            }
            else if (param1 == "scaleX")
            {
                this._flags = this._flags | 8;
                this._destination.relativeFlags = this._destination.relativeFlags | (param3 ? (8) : (0));
                this._destination.scaleX = param2;
            }
            else if (param1 == "scaleY")
            {
                this._flags = this._flags | 16;
                this._destination.relativeFlags = this._destination.relativeFlags | (param3 ? (16) : (0));
                this._destination.scaleY = param2;
            }
            else if (param1 == "scaleZ")
            {
                this._flags = this._flags | 32;
                this._destination.relativeFlags = this._destination.relativeFlags | (param3 ? (32) : (0));
                this._destination.scaleZ = param2;
            }
            else if (param1 == "rotation")
            {
                this._flags = this._flags | 64;
                this._destination.relativeFlags = this._destination.relativeFlags | (param3 ? (64) : (0));
                this._destination.rotation = param2;
            }
            else if (param1 == "rotationX")
            {
                this._flags = this._flags | 128;
                this._destination.relativeFlags = this._destination.relativeFlags | (param3 ? (128) : (0));
                this._destination.rotationX = param2;
            }
            else if (param1 == "rotationY")
            {
                this._flags = this._flags | 256;
                this._destination.relativeFlags = this._destination.relativeFlags | (param3 ? (256) : (0));
                this._destination.rotationY = param2;
            }
            else if (param1 == "rotationZ")
            {
                this._flags = this._flags | 512;
                this._destination.relativeFlags = this._destination.relativeFlags | (param3 ? (512) : (0));
                this._destination.rotationZ = param2;
            }
            else if (param1 == "alpha")
            {
                this._flags = this._flags | 1024;
                this._destination.relativeFlags = this._destination.relativeFlags | (param3 ? (1024) : (0));
                this._destination.alpha = param2;
            }
            else if (param1 == "width")
            {
                this._flags = this._flags | 2048;
                this._destination.relativeFlags = this._destination.relativeFlags | (param3 ? (2048) : (0));
                this._destination.width = param2;
            }
            else if (param1 == "height")
            {
                this._flags = this._flags | 4096;
                this._destination.relativeFlags = this._destination.relativeFlags | (param3 ? (4096) : (0));
                this._destination.height = param2;
            }
            return;
        }// end function

        protected function setFilterByClass(param1:BitmapFilter, param2:Class) : void
        {
            var _loc_3:* = this._target.filters;
            var _loc_4:* = _loc_3.length;
            var _loc_5:uint = 0;
            while (_loc_5 < _loc_4)
            {
                
                if (_loc_3[_loc_5] is param2)
                {
                    _loc_3[_loc_5] = param1;
                    this._target.filters = _loc_3;
                    return;
                }
                _loc_5 = _loc_5 + 1;
            }
            _loc_3.push(param1);
            this._target.filters = _loc_3;
            return;
        }// end function

        override public function get target() : Object
        {
            return this._target;
        }// end function

        protected function getFilterByClass(param1:Class) : BitmapFilter
        {
            var _loc_2:BitmapFilter = null;
            var _loc_3:* = this._target.filters;
            var _loc_4:* = _loc_3.length;
            var _loc_5:uint = 0;
            while (_loc_5 < _loc_4)
            {
                
                var _loc_6:* = _loc_3[_loc_5] as BitmapFilter;
                _loc_2 = _loc_3[_loc_5] as BitmapFilter;
                if (_loc_6 is param1)
                {
                    return _loc_2;
                }
                _loc_5 = _loc_5 + 1;
            }
            _loc_2 = new param1;
            _loc_3.push(_loc_2);
            this._target.filters = _loc_3;
            return _loc_2;
        }// end function

        override protected function newInstance() : AbstractUpdater
        {
            return new DisplayObjectUpdater();
        }// end function

        override public function setSourceValue(param1:String, param2:Number, param3:Boolean = false) : void
        {
            if (param1 == "x")
            {
                this._flags = this._flags | 1;
                this._source.relativeFlags = this._source.relativeFlags | (param3 ? (1) : (0));
                this._source.x = param2;
            }
            else if (param1 == "y")
            {
                this._flags = this._flags | 2;
                this._source.relativeFlags = this._source.relativeFlags | (param3 ? (2) : (0));
                this._source.y = param2;
            }
            else if (param1 == "z")
            {
                this._flags = this._flags | 4;
                this._source.relativeFlags = this._source.relativeFlags | (param3 ? (4) : (0));
                this._source.z = param2;
            }
            else if (param1 == "scaleX")
            {
                this._flags = this._flags | 8;
                this._source.relativeFlags = this._source.relativeFlags | (param3 ? (8) : (0));
                this._source.scaleX = param2;
            }
            else if (param1 == "scaleY")
            {
                this._flags = this._flags | 16;
                this._source.relativeFlags = this._source.relativeFlags | (param3 ? (16) : (0));
                this._source.scaleY = param2;
            }
            else if (param1 == "scaleZ")
            {
                this._flags = this._flags | 32;
                this._source.relativeFlags = this._source.relativeFlags | (param3 ? (32) : (0));
                this._source.scaleZ = param2;
            }
            else if (param1 == "rotation")
            {
                this._flags = this._flags | 64;
                this._source.relativeFlags = this._source.relativeFlags | (param3 ? (64) : (0));
                this._source.rotation = param2;
            }
            else if (param1 == "rotationX")
            {
                this._flags = this._flags | 128;
                this._source.relativeFlags = this._source.relativeFlags | (param3 ? (128) : (0));
                this._source.rotationX = param2;
            }
            else if (param1 == "rotationY")
            {
                this._flags = this._flags | 256;
                this._source.relativeFlags = this._source.relativeFlags | (param3 ? (256) : (0));
                this._source.rotationY = param2;
            }
            else if (param1 == "rotationZ")
            {
                this._flags = this._flags | 512;
                this._source.relativeFlags = this._source.relativeFlags | (param3 ? (512) : (0));
                this._source.rotationZ = param2;
            }
            else if (param1 == "alpha")
            {
                this._flags = this._flags | 1024;
                this._source.relativeFlags = this._source.relativeFlags | (param3 ? (1024) : (0));
                this._source.alpha = param2;
            }
            else if (param1 == "width")
            {
                this._flags = this._flags | 2048;
                this._source.relativeFlags = this._source.relativeFlags | (param3 ? (2048) : (0));
                this._source.width = param2;
            }
            else if (param1 == "height")
            {
                this._flags = this._flags | 4096;
                this._source.relativeFlags = this._source.relativeFlags | (param3 ? (4096) : (0));
                this._source.height = param2;
            }
            return;
        }// end function

        override protected function updateObject(param1:Number) : void
        {
            var _loc_2:* = this._target;
            var _loc_3:* = this._destination;
            var _loc_4:* = this._source;
            var _loc_5:* = this._flags;
            var _loc_6:* = 1 - param1;
            if ((_loc_5 & 1) != 0)
            {
                _loc_2.x = _loc_4.x * _loc_6 + _loc_3.x * param1;
            }
            if ((_loc_5 & 2) != 0)
            {
                _loc_2.y = _loc_4.y * _loc_6 + _loc_3.y * param1;
            }
            if ((_loc_5 & 4) != 0)
            {
                _loc_2.z = _loc_4.z * _loc_6 + _loc_3.z * param1;
            }
            if ((_loc_5 & 56) != 0)
            {
                if ((_loc_5 & 8) != 0)
                {
                    _loc_2.scaleX = _loc_4.scaleX * _loc_6 + _loc_3.scaleX * param1;
                }
                if ((_loc_5 & 16) != 0)
                {
                    _loc_2.scaleY = _loc_4.scaleY * _loc_6 + _loc_3.scaleY * param1;
                }
                if ((_loc_5 & 32) != 0)
                {
                    _loc_2.scaleZ = _loc_4.scaleZ * _loc_6 + _loc_3.scaleZ * param1;
                }
            }
            if ((_loc_5 & 960) != 0)
            {
                if ((_loc_5 & 64) != 0)
                {
                    _loc_2.rotation = _loc_4.rotation * _loc_6 + _loc_3.rotation * param1;
                }
                if ((_loc_5 & 128) != 0)
                {
                    _loc_2.rotationX = _loc_4.rotationX * _loc_6 + _loc_3.rotationX * param1;
                }
                if ((_loc_5 & 256) != 0)
                {
                    _loc_2.rotationY = _loc_4.rotationY * _loc_6 + _loc_3.rotationY * param1;
                }
                if ((_loc_5 & 512) != 0)
                {
                    _loc_2.rotationZ = _loc_4.rotationZ * _loc_6 + _loc_3.rotationZ * param1;
                }
            }
            if ((_loc_5 & 7168) != 0)
            {
                if ((_loc_5 & 1024) != 0)
                {
                    _loc_2.alpha = _loc_4.alpha * _loc_6 + _loc_3.alpha * param1;
                }
                if ((_loc_5 & 2048) != 0)
                {
                    _loc_2.width = _loc_4.width * _loc_6 + _loc_3.width * param1;
                }
                if ((_loc_5 & 4096) != 0)
                {
                    _loc_2.height = _loc_4.height * _loc_6 + _loc_3.height * param1;
                }
            }
            return;
        }// end function

        override public function set target(param1:Object) : void
        {
            this._target = param1 as DisplayObject;
            return;
        }// end function

        override protected function resolveValues() : void
        {
            var _loc_1:* = this._target;
            var _loc_2:* = this._destination;
            var _loc_3:* = this._source;
            var _loc_4:* = this._flags;
            if ((this._flags & 1) != 0)
            {
                if (isNaN(_loc_3.x))
                {
                    _loc_3.x = _loc_1.x;
                }
                else if ((_loc_3.relativeFlags & 1) != 0)
                {
                    _loc_3.x = _loc_3.x + _loc_1.x;
                }
                if (isNaN(_loc_2.x))
                {
                    _loc_2.x = _loc_1.x;
                }
                else if ((_loc_2.relativeFlags & 1) != 0)
                {
                    _loc_2.x = _loc_2.x + _loc_1.x;
                }
            }
            if ((_loc_4 & 2) != 0)
            {
                if (isNaN(_loc_3.y))
                {
                    _loc_3.y = _loc_1.y;
                }
                else if ((_loc_3.relativeFlags & 2) != 0)
                {
                    _loc_3.y = _loc_3.y + _loc_1.y;
                }
                if (isNaN(_loc_2.y))
                {
                    _loc_2.y = _loc_1.y;
                }
                else if ((_loc_2.relativeFlags & 2) != 0)
                {
                    _loc_2.y = _loc_2.y + _loc_1.y;
                }
            }
            if ((_loc_4 & 4) != 0)
            {
                if (isNaN(_loc_3.z))
                {
                    _loc_3.z = _loc_1.z;
                }
                else if ((_loc_3.relativeFlags & 4) != 0)
                {
                    _loc_3.z = _loc_3.z + _loc_1.z;
                }
                if (isNaN(_loc_2.z))
                {
                    _loc_2.z = _loc_1.z;
                }
                else if ((_loc_2.relativeFlags & 4) != 0)
                {
                    _loc_2.z = _loc_2.z + _loc_1.z;
                }
            }
            if ((_loc_4 & 8) != 0)
            {
                if (isNaN(_loc_3.scaleX))
                {
                    _loc_3.scaleX = _loc_1.scaleX;
                }
                else if ((_loc_3.relativeFlags & 8) != 0)
                {
                    _loc_3.scaleX = _loc_3.scaleX + _loc_1.scaleX;
                }
                if (isNaN(_loc_2.scaleX))
                {
                    _loc_2.scaleX = _loc_1.scaleX;
                }
                else if ((_loc_2.relativeFlags & 8) != 0)
                {
                    _loc_2.scaleX = _loc_2.scaleX + _loc_1.scaleX;
                }
            }
            if ((_loc_4 & 16) != 0)
            {
                if (isNaN(_loc_3.scaleY))
                {
                    _loc_3.scaleY = _loc_1.scaleY;
                }
                else if ((_loc_3.relativeFlags & 16) != 0)
                {
                    _loc_3.scaleY = _loc_3.scaleY + _loc_1.scaleY;
                }
                if (isNaN(_loc_2.scaleY))
                {
                    _loc_2.scaleY = _loc_1.scaleY;
                }
                else if ((_loc_2.relativeFlags & 16) != 0)
                {
                    _loc_2.scaleY = _loc_2.scaleY + _loc_1.scaleY;
                }
            }
            if ((_loc_4 & 32) != 0)
            {
                if (isNaN(_loc_3.scaleZ))
                {
                    _loc_3.scaleZ = _loc_1.scaleZ;
                }
                else if ((_loc_3.relativeFlags & 32) != 0)
                {
                    _loc_3.scaleZ = _loc_3.scaleZ + _loc_1.scaleZ;
                }
                if (isNaN(_loc_2.scaleZ))
                {
                    _loc_2.scaleZ = _loc_1.scaleZ;
                }
                else if ((_loc_2.relativeFlags & 32) != 0)
                {
                    _loc_2.scaleZ = _loc_2.scaleZ + _loc_1.scaleZ;
                }
            }
            if ((_loc_4 & 64) != 0)
            {
                if (isNaN(_loc_3.rotation))
                {
                    _loc_3.rotation = _loc_1.rotation;
                }
                else if ((_loc_3.relativeFlags & 64) != 0)
                {
                    _loc_3.rotation = _loc_3.rotation + _loc_1.rotation;
                }
                if (isNaN(_loc_2.rotation))
                {
                    _loc_2.rotation = _loc_1.rotation;
                }
                else if ((_loc_2.relativeFlags & 64) != 0)
                {
                    _loc_2.rotation = _loc_2.rotation + _loc_1.rotation;
                }
            }
            if ((_loc_4 & 128) != 0)
            {
                if (isNaN(_loc_3.rotationX))
                {
                    _loc_3.rotationX = _loc_1.rotationX;
                }
                else if ((_loc_3.relativeFlags & 128) != 0)
                {
                    _loc_3.rotationX = _loc_3.rotationX + _loc_1.rotationX;
                }
                if (isNaN(_loc_2.rotationX))
                {
                    _loc_2.rotationX = _loc_1.rotationX;
                }
                else if ((_loc_2.relativeFlags & 128) != 0)
                {
                    _loc_2.rotationX = _loc_2.rotationX + _loc_1.rotationX;
                }
            }
            if ((_loc_4 & 256) != 0)
            {
                if (isNaN(_loc_3.rotationY))
                {
                    _loc_3.rotationY = _loc_1.rotationY;
                }
                else if ((_loc_3.relativeFlags & 256) != 0)
                {
                    _loc_3.rotationY = _loc_3.rotationY + _loc_1.rotationY;
                }
                if (isNaN(_loc_2.rotationY))
                {
                    _loc_2.rotationY = _loc_1.rotationY;
                }
                else if ((_loc_2.relativeFlags & 256) != 0)
                {
                    _loc_2.rotationY = _loc_2.rotationY + _loc_1.rotationY;
                }
            }
            if ((_loc_4 & 512) != 0)
            {
                if (isNaN(_loc_3.rotationZ))
                {
                    _loc_3.rotationZ = _loc_1.rotationZ;
                }
                else if ((_loc_3.relativeFlags & 512) != 0)
                {
                    _loc_3.rotationZ = _loc_3.rotationZ + _loc_1.rotationZ;
                }
                if (isNaN(_loc_2.rotationZ))
                {
                    _loc_2.rotationZ = _loc_1.rotationZ;
                }
                else if ((_loc_2.relativeFlags & 512) != 0)
                {
                    _loc_2.rotationZ = _loc_2.rotationZ + _loc_1.rotationZ;
                }
            }
            if ((_loc_4 & 1024) != 0)
            {
                if (isNaN(_loc_3.alpha))
                {
                    _loc_3.alpha = _loc_1.alpha;
                }
                else if ((_loc_3.relativeFlags & 1024) != 0)
                {
                    _loc_3.alpha = _loc_3.alpha + _loc_1.alpha;
                }
                if (isNaN(_loc_2.alpha))
                {
                    _loc_2.alpha = _loc_1.alpha;
                }
                else if ((_loc_2.relativeFlags & 1024) != 0)
                {
                    _loc_2.alpha = _loc_2.alpha + _loc_1.alpha;
                }
            }
            if ((_loc_4 & 2048) != 0)
            {
                if (isNaN(_loc_3.width))
                {
                    _loc_3.width = _loc_1.width;
                }
                else if ((_loc_3.relativeFlags & 2048) != 0)
                {
                    _loc_3.width = _loc_3.width + _loc_1.width;
                }
                if (isNaN(_loc_2.width))
                {
                    _loc_2.width = _loc_1.width;
                }
                else if ((_loc_2.relativeFlags & 2048) != 0)
                {
                    _loc_2.width = _loc_2.width + _loc_1.width;
                }
            }
            if ((_loc_4 & 4096) != 0)
            {
                if (isNaN(_loc_3.height))
                {
                    _loc_3.height = _loc_1.height;
                }
                else if ((_loc_3.relativeFlags & 4096) != 0)
                {
                    _loc_3.height = _loc_3.height + _loc_1.height;
                }
                if (isNaN(_loc_2.height))
                {
                    _loc_2.height = _loc_1.height;
                }
                else if ((_loc_2.relativeFlags & 4096) != 0)
                {
                    _loc_2.height = _loc_2.height + _loc_1.height;
                }
            }
            return;
        }// end function

        override public function getObject(param1:String) : Object
        {
            if (param1 == "_blurFilter")
            {
                return this.getFilterByClass(BlurFilter);
            }
            if (param1 == "_glowFilter")
            {
                return this.getFilterByClass(GlowFilter);
            }
            if (param1 == "_dropShadowFilter")
            {
                return this.getFilterByClass(DropShadowFilter);
            }
            if (param1 == "_colorMatrixFilter")
            {
                return this.getFilterByClass(ColorMatrixFilter);
            }
            if (param1 == "_bevelFilter")
            {
                return this.getFilterByClass(BevelFilter);
            }
            if (param1 == "_gradientGlowFilter")
            {
                return this.getFilterByClass(GradientGlowFilter);
            }
            if (param1 == "_gradientBevelFilter")
            {
                return this.getFilterByClass(GradientBevelFilter);
            }
            if (param1 == "_convolutionFilter")
            {
                return this.getFilterByClass(ConvolutionFilter);
            }
            if (param1 == "_displacementMapFilter")
            {
                return this.getFilterByClass(DisplacementMapFilter);
            }
            if (param1 == "_shaderFilter")
            {
                return this.getFilterByClass(ShaderFilter);
            }
            return null;
        }// end function

        override protected function copyFrom(param1:AbstractUpdater) : void
        {
            super.copyFrom(param1);
            var _loc_2:* = param1 as DisplayObjectUpdater;
            this._target = _loc_2._target;
            this._source.copyFrom(_loc_2._source);
            this._destination.copyFrom(_loc_2._destination);
            this._flags = _loc_2._flags;
            return;
        }// end function

        public static function register(param1:ClassRegistry) : void
        {
            param1.registerClassWithTargetClassAndPropertyNames(DisplayObjectUpdater, DisplayObject, TARGET_PROPERTIES);
            return;
        }// end function

    }
}

class DisplayObjectParameter extends Object
{
    public var width:Number;
    public var scaleX:Number;
    public var scaleY:Number;
    public var scaleZ:Number;
    public var rotationX:Number;
    public var rotationY:Number;
    public var rotationZ:Number;
    public var alpha:Number;
    public var relativeFlags:uint = 0;
    public var height:Number;
    public var x:Number;
    public var y:Number;
    public var z:Number;
    public var rotation:Number;

    function DisplayObjectParameter()
    {
        return;
    }// end function

    public function copyFrom(param1:DisplayObjectParameter) : void
    {
        this.relativeFlags = param1.relativeFlags;
        this.x = param1.x;
        this.y = param1.y;
        this.z = param1.z;
        this.scaleX = param1.scaleX;
        this.scaleY = param1.scaleY;
        this.scaleZ = param1.scaleZ;
        this.rotation = param1.rotation;
        this.rotationX = param1.rotationX;
        this.rotationY = param1.rotationY;
        this.rotationZ = param1.rotationZ;
        this.alpha = param1.alpha;
        this.width = param1.width;
        this.height = param1.height;
        return;
    }// end function

}

