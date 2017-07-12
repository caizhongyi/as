package org.libspark.betweenas3.core.updaters.geom
{
    import flash.geom.*;
    import org.libspark.betweenas3.core.updaters.*;
    import org.libspark.betweenas3.core.utils.*;

    public class PointUpdater extends AbstractUpdater
    {
        protected var _sx:Number;
        protected var _sy:Number;
        protected var _flags:uint = 0;
        protected var _target:Point = null;
        protected var _fx:Boolean = false;
        protected var _fy:Boolean = false;
        protected var _dx:Number;
        protected var _dy:Number;
        public static const TARGET_PROPERTIES:Array = ["x", "y"];

        public function PointUpdater()
        {
            return;
        }// end function

        override public function setSourceValue(param1:String, param2:Number, param3:Boolean = false) : void
        {
            if (param1 == "x")
            {
                this._fx = true;
                this._sx = param2;
                this._flags = this._flags | (param3 ? (1) : (0));
            }
            else if (param1 == "y")
            {
                this._fy = true;
                this._sy = param2;
                this._flags = this._flags | (param3 ? (4) : (0));
            }
            return;
        }// end function

        override protected function newInstance() : AbstractUpdater
        {
            return new PointUpdater();
        }// end function

        override public function get target() : Object
        {
            return this._target;
        }// end function

        override public function setDestinationValue(param1:String, param2:Number, param3:Boolean = false) : void
        {
            if (param1 == "x")
            {
                this._fx = true;
                this._dx = param2;
                this._flags = this._flags | (param3 ? (2) : (0));
            }
            else if (param1 == "y")
            {
                this._fy = true;
                this._dy = param2;
                this._flags = this._flags | (param3 ? (8) : (0));
            }
            return;
        }// end function

        override public function set target(param1:Object) : void
        {
            this._target = param1 as Point;
            return;
        }// end function

        override protected function resolveValues() : void
        {
            var _loc_1:* = this._target;
            if (this._fx)
            {
                if (isNaN(this._sx))
                {
                    this._sx = _loc_1.x;
                }
                else if ((this._flags & 1) != 0)
                {
                    this._sx = this._sx + _loc_1.x;
                }
                if (isNaN(this._dx))
                {
                    this._dx = _loc_1.x;
                }
                else if ((this._flags & 2) != 0)
                {
                    this._dx = this._dx + _loc_1.x;
                }
            }
            if (this._fy)
            {
                if (isNaN(this._sy))
                {
                    this._sy = _loc_1.y;
                }
                else if ((this._flags & 4) != 0)
                {
                    this._sy = this._sy + _loc_1.y;
                }
                if (isNaN(this._dy))
                {
                    this._dy = _loc_1.y;
                }
                else if ((this._flags & 8) != 0)
                {
                    this._dy = this._dy + _loc_1.y;
                }
            }
            return;
        }// end function

        override protected function updateObject(param1:Number) : void
        {
            var _loc_2:* = this._target;
            var _loc_3:* = 1 - param1;
            if (this._fx)
            {
                _loc_2.x = this._sx * _loc_3 + this._dx * param1;
            }
            if (this._fy)
            {
                _loc_2.y = this._sy * _loc_3 + this._dy * param1;
            }
            return;
        }// end function

        override protected function copyFrom(param1:AbstractUpdater) : void
        {
            super.copyFrom(param1);
            var _loc_2:* = param1 as PointUpdater;
            this._target = _loc_2._target;
            this._sx = _loc_2._sx;
            this._sy = _loc_2._sy;
            this._dx = _loc_2._dx;
            this._dy = _loc_2._dy;
            this._fx = _loc_2._fx;
            this._fy = _loc_2._fy;
            this._flags = _loc_2._flags;
            return;
        }// end function

        public static function register(param1:ClassRegistry) : void
        {
            param1.registerClassWithTargetClassAndPropertyNames(PointUpdater, Point, TARGET_PROPERTIES);
            return;
        }// end function

    }
}
