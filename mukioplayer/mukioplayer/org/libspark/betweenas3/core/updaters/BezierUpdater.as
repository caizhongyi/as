package org.libspark.betweenas3.core.updaters
{
    import __AS3__.vec.*;
    import flash.utils.*;

    public class BezierUpdater extends AbstractUpdater
    {
        protected var _destination:Dictionary;
        protected var _controlPoint:Dictionary;
        protected var _target:Object = null;
        protected var _relativeMap:Dictionary;
        protected var _source:Dictionary;

        public function BezierUpdater()
        {
            this._source = new Dictionary();
            this._destination = new Dictionary();
            this._controlPoint = new Dictionary();
            this._relativeMap = new Dictionary();
            return;
        }// end function

        override public function setObject(param1:String, param2:Object) : void
        {
            this._target[param1] = param2;
            return;
        }// end function

        override public function set target(param1:Object) : void
        {
            this._target = param1;
            return;
        }// end function

        override public function setDestinationValue(param1:String, param2:Number, param3:Boolean = false) : void
        {
            this._destination[param1] = param2;
            this._relativeMap["dest." + param1] = param3;
            return;
        }// end function

        override public function get target() : Object
        {
            return this._target;
        }// end function

        override public function setSourceValue(param1:String, param2:Number, param3:Boolean = false) : void
        {
            this._source[param1] = param2;
            this._relativeMap["source." + param1] = param3;
            return;
        }// end function

        override protected function newInstance() : AbstractUpdater
        {
            return new BezierUpdater();
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

        override protected function updateObject(param1:Number) : void
        {
            var _loc_6:Number = NaN;
            var _loc_8:Vector.<Number> = null;
            var _loc_9:uint = 0;
            var _loc_10:uint = 0;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:Number = NaN;
            var _loc_14:String = null;
            var _loc_2:* = 1 - param1;
            var _loc_3:* = this._target;
            var _loc_4:* = this._destination;
            var _loc_5:* = this._source;
            var _loc_7:* = this._controlPoint;
            for (_loc_14 in _loc_4)
            {
                
                _loc_6 = _loc_5[_loc_14];
                var _loc_17:* = this._controlPoint[_loc_14] as Vector.<Number>;
                _loc_8 = this._controlPoint[_loc_14] as Vector.<Number>;
                if (param1 != 1 && _loc_17 != null)
                {
                    var _loc_17:* = _loc_8.length;
                    _loc_9 = _loc_8.length;
                    if (_loc_17 == 1)
                    {
                        _loc_3[_loc_14] = _loc_6 + param1 * (2 * _loc_2 * (_loc_8[0] - _loc_6) + param1 * (_loc_4[_loc_14] - _loc_6));
                    }
                    else
                    {
                        if (param1 < 0)
                        {
                            _loc_10 = 0;
                        }
                        else if (param1 > 1)
                        {
                            _loc_10 = _loc_9 - 1;
                        }
                        else
                        {
                            _loc_10 = param1 * _loc_9 >> 0;
                        }
                        _loc_11 = (param1 - _loc_10 * (1 / _loc_9)) * _loc_9;
                        if (_loc_10 == 0)
                        {
                            _loc_12 = _loc_6;
                            _loc_13 = (_loc_8[0] + _loc_8[1]) / 2;
                        }
                        else if (_loc_10 == (_loc_9 - 1))
                        {
                            _loc_12 = (_loc_8[(_loc_10 - 1)] + _loc_8[_loc_10]) / 2;
                            _loc_13 = _loc_4[_loc_14];
                        }
                        else
                        {
                            _loc_12 = (_loc_8[(_loc_10 - 1)] + _loc_8[_loc_10]) / 2;
                            _loc_13 = (_loc_8[_loc_10] + _loc_8[(_loc_10 + 1)]) / 2;
                        }
                        _loc_3[_loc_14] = _loc_12 + _loc_11 * (2 * (1 - _loc_11) * (_loc_8[_loc_10] - _loc_12) + _loc_11 * (_loc_13 - _loc_12));
                    }
                    continue;
                }
                _loc_3[_loc_14] = _loc_6 * _loc_2 + _loc_4[_loc_14] * param1;
            }
            return;
        }// end function

        override protected function resolveValues() : void
        {
            var _loc_1:String = null;
            var _loc_6:Vector.<Number> = null;
            var _loc_7:uint = 0;
            var _loc_8:uint = 0;
            var _loc_2:* = this._target;
            var _loc_3:* = this._source;
            var _loc_4:* = this._destination;
            var _loc_5:* = this._controlPoint;
            var _loc_9:* = this._relativeMap;
            for (_loc_1 in _loc_3)
            {
                
                if (_loc_4[_loc_1] == undefined)
                {
                    _loc_4[_loc_1] = _loc_2[_loc_1];
                }
                if (_loc_9["source." + _loc_1])
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
                if (_loc_9["dest." + _loc_1])
                {
                    _loc_4[_loc_1] = _loc_4[_loc_1] + _loc_2[_loc_1];
                }
            }
            for (_loc_1 in _loc_5)
            {
                
                _loc_6 = _loc_5[_loc_1] as Vector.<Number>;
                _loc_7 = _loc_6.length;
                _loc_8 = 0;
                while (_loc_8 < _loc_7)
                {
                    
                    if (_loc_9["cp." + _loc_1 + "." + _loc_8])
                    {
                        _loc_6[_loc_8] = _loc_6[_loc_8] + _loc_2[_loc_1];
                    }
                    _loc_8 = _loc_8 + 1;
                }
            }
            return;
        }// end function

        public function addControlPoint(param1:String, param2:Number, param3:Boolean = false) : void
        {
            var _loc_4:* = this._controlPoint[param1] as Vector.<Number>;
            if (this._controlPoint[param1] as Vector.<Number> == null)
            {
                var _loc_5:* = new Vector.<Number>;
                _loc_4 = new Vector.<Number>;
                this._controlPoint[param1] = _loc_5;
            }
            _loc_4.push(param2);
            this._relativeMap["cp." + param1 + "." + _loc_4.length] = param3;
            return;
        }// end function

        override public function getObject(param1:String) : Object
        {
            return this._target[param1];
        }// end function

        override protected function copyFrom(param1:AbstractUpdater) : void
        {
            super.copyFrom(param1);
            var _loc_2:* = param1 as BezierUpdater;
            this._target = _loc_2._target;
            this.copyObject(this._source, _loc_2._source);
            this.copyObject(this._destination, _loc_2._destination);
            this.copyObject(this._controlPoint, _loc_2._controlPoint);
            this.copyObject(this._relativeMap, _loc_2._relativeMap);
            return;
        }// end function

    }
}
