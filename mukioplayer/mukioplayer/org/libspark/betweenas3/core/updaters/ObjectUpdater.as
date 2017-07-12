package org.libspark.betweenas3.core.updaters
{
    import flash.utils.*;
    import org.libspark.betweenas3.core.utils.*;

    public class ObjectUpdater extends AbstractUpdater
    {
        protected var _destination:Dictionary;
        protected var _target:Object = null;
        protected var _relativeMap:Dictionary;
        protected var _source:Dictionary;

        public function ObjectUpdater()
        {
            this._source = new Dictionary();
            this._destination = new Dictionary();
            this._relativeMap = new Dictionary();
            return;
        }// end function

        override public function setObject(param1:String, param2:Object) : void
        {
            this._target[param1] = param2;
            return;
        }// end function

        override public function setDestinationValue(param1:String, param2:Number, param3:Boolean = false) : void
        {
            this._destination[param1] = param2;
            this._relativeMap["dest." + param1] = param3;
            return;
        }// end function

        override protected function newInstance() : AbstractUpdater
        {
            return new ObjectUpdater();
        }// end function

        override public function get target() : Object
        {
            return this._target;
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

        override public function setSourceValue(param1:String, param2:Number, param3:Boolean = false) : void
        {
            this._source[param1] = param2;
            this._relativeMap["source." + param1] = param3;
            return;
        }// end function

        override protected function updateObject(param1:Number) : void
        {
            var _loc_6:String = null;
            var _loc_2:* = 1 - param1;
            var _loc_3:* = this._target;
            var _loc_4:* = this._destination;
            var _loc_5:* = this._source;
            for (_loc_6 in _loc_4)
            {
                
                _loc_3[_loc_6] = _loc_5[_loc_6] * _loc_2 + _loc_4[_loc_6] * param1;
            }
            return;
        }// end function

        override public function set target(param1:Object) : void
        {
            this._target = param1;
            return;
        }// end function

        override protected function resolveValues() : void
        {
            var _loc_1:String = null;
            var _loc_2:* = this._target;
            var _loc_3:* = this._source;
            var _loc_4:* = this._destination;
            var _loc_5:* = this._relativeMap;
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
            }
            return;
        }// end function

        override public function getObject(param1:String) : Object
        {
            return this._target[param1];
        }// end function

        override protected function copyFrom(param1:AbstractUpdater) : void
        {
            super.copyFrom(param1);
            var _loc_2:* = param1 as ObjectUpdater;
            this._target = _loc_2._target;
            this.copyObject(this._source, _loc_2._source);
            this.copyObject(this._destination, _loc_2._destination);
            this.copyObject(this._relativeMap, _loc_2._relativeMap);
            return;
        }// end function

        public static function register(param1:ClassRegistry) : void
        {
            param1.registerClassWithTargetClassAndPropertyName(ObjectUpdater, Object, "*");
            return;
        }// end function

    }
}
