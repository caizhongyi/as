package org.libspark.betweenas3.core.updaters.display
{
    import flash.display.*;
    import org.libspark.betweenas3.core.updaters.*;
    import org.libspark.betweenas3.core.utils.*;

    public class MovieClipUpdater extends AbstractUpdater
    {
        protected var _flags:uint = 0;
        protected var _destination:MovieClipParameter;
        protected var _target:MovieClip = null;
        protected var _source:MovieClipParameter;
        public static const TARGET_PROPERTIES:Array = ["_frame"];

        public function MovieClipUpdater()
        {
            this._source = new MovieClipParameter();
            this._destination = new MovieClipParameter();
            return;
        }// end function

        override public function setDestinationValue(param1:String, param2:Number, param3:Boolean = false) : void
        {
            if (param1 == "_frame")
            {
                this._flags = this._flags | 1;
                this._destination.relativeFlags = this._destination.relativeFlags | (param3 ? (1) : (0));
                this._destination.frame = param2;
            }
            return;
        }// end function

        override public function set target(param1:Object) : void
        {
            this._target = param1 as MovieClip;
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
                _loc_2.gotoAndStop(Math.round(_loc_4.frame * _loc_6 + _loc_3.frame * param1));
            }
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
                if (isNaN(_loc_3.frame))
                {
                    _loc_3.frame = _loc_1.currentFrame;
                }
                else if ((_loc_3.relativeFlags & 1) != 0)
                {
                    _loc_3.frame = _loc_3.frame + _loc_1.currentFrame;
                }
                if (isNaN(_loc_2.frame))
                {
                    _loc_2.frame = _loc_1.currentFrame;
                }
                else if ((_loc_2.relativeFlags & 1) != 0)
                {
                    _loc_2.frame = _loc_2.frame + _loc_1.currentFrame;
                }
            }
            return;
        }// end function

        override public function get target() : Object
        {
            return this._target;
        }// end function

        override protected function newInstance() : AbstractUpdater
        {
            return new MovieClipUpdater();
        }// end function

        override public function setSourceValue(param1:String, param2:Number, param3:Boolean = false) : void
        {
            if (param1 == "_frame")
            {
                this._flags = this._flags | 1;
                this._source.relativeFlags = this._source.relativeFlags | (param3 ? (1) : (0));
                this._source.frame = param2;
            }
            return;
        }// end function

        override protected function copyFrom(param1:AbstractUpdater) : void
        {
            super.copyFrom(param1);
            var _loc_2:* = param1 as MovieClipUpdater;
            this._target = _loc_2._target;
            this._source.copyFrom(_loc_2._source);
            this._destination.copyFrom(_loc_2._destination);
            this._flags = _loc_2._flags;
            return;
        }// end function

        public static function register(param1:ClassRegistry) : void
        {
            param1.registerClassWithTargetClassAndPropertyNames(MovieClipUpdater, MovieClip, TARGET_PROPERTIES);
            return;
        }// end function

    }
}

class MovieClipParameter extends Object
{
    public var relativeFlags:uint = 0;
    public var frame:Number;

    function MovieClipParameter()
    {
        return;
    }// end function

    public function copyFrom(param1:MovieClipParameter) : void
    {
        this.relativeFlags = param1.relativeFlags;
        this.frame = param1.frame;
        return;
    }// end function

}

