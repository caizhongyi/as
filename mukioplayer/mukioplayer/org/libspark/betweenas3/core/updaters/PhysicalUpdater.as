package org.libspark.betweenas3.core.updaters
{
    import flash.utils.*;
    import org.libspark.betweenas3.core.easing.*;

    public class PhysicalUpdater extends Object implements IPhysicalUpdater
    {
        protected var _easing:IPhysicalEasing = null;
        protected var _destination:Dictionary;
        protected var _maxDuration:Number = 0;
        protected var _isResolved:Boolean = false;
        protected var _target:Object = null;
        protected var _duration:Dictionary;
        protected var _relativeMap:Dictionary;
        protected var _source:Dictionary;

        public function PhysicalUpdater()
        {
            this._source = new Dictionary();
            this._destination = new Dictionary();
            this._relativeMap = new Dictionary();
            this._duration = new Dictionary();
            return;
        }// end function

        public function setObject(param1:String, param2:Object) : void
        {
            this._target[param1] = param2;
            return;
        }// end function

        public function setDestinationValue(param1:String, param2:Number, param3:Boolean = false) : void
        {
            this._destination[param1] = param2;
            this._relativeMap["dest." + param1] = param3;
            return;
        }// end function

        protected function copyFrom(param1:PhysicalUpdater) : void
        {
            var _loc_2:* = param1 as PhysicalUpdater;
            this._target = _loc_2._target;
            this._easing = _loc_2._easing;
            this.copyObject(this._source, _loc_2._source);
            this.copyObject(this._destination, _loc_2._destination);
            this.copyObject(this._relativeMap, _loc_2._relativeMap);
            return;
        }// end function

        public function update(param1:Number) : void
        {
            var _loc_2:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_9:String = null;
            if (!this._isResolved)
            {
                this.resolveValues();
            }
            var _loc_3:* = this._target;
            var _loc_4:* = this._easing;
            var _loc_5:* = this._destination;
            var _loc_6:* = this._source;
            var _loc_8:* = this._duration;
            for (_loc_9 in _loc_5)
            {
                
                if (param1 >= _loc_8[_loc_9])
                {
                    _loc_3[_loc_9] = _loc_5[_loc_9];
                    continue;
                }
                _loc_7 = _loc_6[_loc_9];
                _loc_3[_loc_9] = _loc_4.calculate(param1, _loc_7, _loc_5[_loc_9] - _loc_7);
            }
            return;
        }// end function

        private function copyObject(param1:Object, param2:Object) : void
        {
            var _loc_3:String = null;
            for (_loc_3 in param2)
            {
                
                param1[_loc_3] = param2[_loc_3];
            }
            return;
        }// end function

        public function get duration() : Number
        {
            if (!this._isResolved)
            {
                this.resolveValues();
            }
            return this._maxDuration;
        }// end function

        protected function newInstance() : PhysicalUpdater
        {
            return new PhysicalUpdater();
        }// end function

        public function set easing(param1:IPhysicalEasing) : void
        {
            this._easing = param1;
            return;
        }// end function

        public function get target() : Object
        {
            return this._target;
        }// end function

        public function clone() : IUpdater
        {
            var _loc_1:* = this.newInstance();
            if (_loc_1 != null)
            {
                _loc_1.copyFrom(this);
            }
            return _loc_1;
        }// end function

        public function set target(param1:Object) : void
        {
            this._target = param1;
            return;
        }// end function

        public function setSourceValue(param1:String, param2:Number, param3:Boolean = false) : void
        {
            this._source[param1] = param2;
            this._relativeMap["source." + param1] = param3;
            return;
        }// end function

        protected function resolveValues() : void
        {
            var _loc_1:String = null;
            var _loc_7:Number = NaN;
            var _loc_2:* = this._target;
            var _loc_3:* = this._source;
            var _loc_4:* = this._destination;
            var _loc_5:* = this._relativeMap;
            var _loc_6:* = this._duration;
            var _loc_8:Number = 0;
            for (_loc_1 in _loc_3)
            {
                
                if (_loc_4[_loc_1] == undefined)
                {
                    _loc_4[_loc_1] = _loc_2[_loc_1];
                }
                if (_loc_5["source." + _loc_1])
                {
                    _loc_3[_loc_1] = _loc_3[_loc_1] + _loc_2[_loc_1];
                }
            }
            for (_loc_1 in _loc_4)
            {
                
                if (_loc_3[_loc_1] == undefined)
                {
                    _loc_3[_loc_1] = _loc_2[_loc_1];
                }
                if (_loc_5["dest." + _loc_1])
                {
                    _loc_4[_loc_1] = _loc_4[_loc_1] + _loc_2[_loc_1];
                }
                _loc_7 = this._easing.getDuration(_loc_3[_loc_1], _loc_4[_loc_1] - _loc_3[_loc_1]);
                _loc_6[_loc_1] = _loc_7;
                if (_loc_8 < _loc_7)
                {
                    _loc_8 = _loc_7;
                }
            }
            this._maxDuration = _loc_8;
            this._isResolved = true;
            return;
        }// end function

        public function get easing() : IPhysicalEasing
        {
            return this._easing;
        }// end function

        public function getObject(param1:String) : Object
        {
            return this._target[param1];
        }// end function

    }
}
