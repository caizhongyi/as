package org.libspark.betweenas3.core.updaters
{
    import __AS3__.vec.*;
    import flash.utils.*;
    import org.libspark.betweenas3.core.easing.*;
    import org.libspark.betweenas3.core.utils.*;

    public class UpdaterFactory extends Object
    {
        private var _mapPool:Vector.<Dictionary>;
        private var _registry:ClassRegistry;
        private var _poolIndex:uint = 0;
        private var _listPool:Vector.<Vector.<IUpdater>>;

        public function UpdaterFactory(param1:ClassRegistry)
        {
            this._mapPool = new Vector.<Dictionary>;
            this._listPool = new Vector.<Vector.<IUpdater>>;
            this._registry = param1;
            return;
        }// end function

        public function getUpdaterFor(param1:Object, param2:String, param3:Dictionary, param4:Vector.<IUpdater>) : IUpdater
        {
            var _loc_6:IUpdater = null;
            var _loc_5:* = this._registry.getClassByTargetClassAndPropertyName(param1.constructor, param2);
            if (this._registry.getClassByTargetClassAndPropertyName(param1.constructor, param2) != null)
            {
                _loc_6 = param3[_loc_5] as IUpdater;
                if (_loc_6 == null)
                {
                    _loc_6 = new _loc_5;
                    _loc_6.target = param1;
                    param3[_loc_5] = _loc_6;
                    if (param4 != null)
                    {
                        param4.push(_loc_6);
                    }
                }
                return _loc_6;
            }
            return null;
        }// end function

        public function createPhysical(param1:Object, param2:Object, param3:Object, param4:IPhysicalEasing) : IPhysicalUpdater
        {
            var _loc_8:String = null;
            var _loc_9:Object = null;
            var _loc_10:Boolean = false;
            var _loc_11:IPhysicalUpdater = null;
            var _loc_12:IPhysicalUpdater = null;
            var _loc_5:* = new Dictionary();
            var _loc_6:* = new Vector.<IPhysicalUpdater>;
            var _loc_7:* = new PhysicalUpdater();
            new PhysicalUpdater().target = param1;
            _loc_7.easing = param4;
            _loc_6.push(_loc_7);
            if (param3 != null)
            {
                for (_loc_8 in param3)
                {
                    
                    var _loc_15:* = param3[_loc_8];
                    _loc_9 = param3[_loc_8];
                    if (_loc_15 is Number)
                    {
                        var _loc_15:* = /^\$/.test(_loc_8);
                        _loc_10 = /^\$/.test(_loc_8);
                        if (_loc_15)
                        {
                            _loc_8 = _loc_8.substr(1);
                        }
                        _loc_7.setSourceValue(_loc_8, Number(_loc_9), _loc_10);
                        continue;
                    }
                    if (!_loc_5[_loc_8])
                    {
                        _loc_11 = this.createPhysical(_loc_7.getObject(_loc_8), param2 != null ? (param2[_loc_8]) : (null), _loc_9, param4);
                        _loc_6.push(new PhysicalUpdaterLadder(_loc_7, _loc_11, _loc_8));
                        _loc_5[_loc_8] = true;
                    }
                }
            }
            if (param2 != null)
            {
                for (_loc_8 in param2)
                {
                    
                    var _loc_15:* = param2[_loc_8];
                    _loc_9 = param2[_loc_8];
                    if (_loc_15 is Number)
                    {
                        var _loc_15:* = /^\$/.test(_loc_8);
                        _loc_10 = /^\$/.test(_loc_8);
                        if (_loc_15)
                        {
                            _loc_8 = _loc_8.substr(1);
                        }
                        _loc_7.setDestinationValue(_loc_8, Number(_loc_9), _loc_10);
                        continue;
                    }
                    if (!_loc_5[_loc_8])
                    {
                        _loc_11 = this.createPhysical(_loc_7.getObject(_loc_8), null, param3 != null ? (param3[_loc_8]) : (null), param4);
                        _loc_6.push(new PhysicalUpdaterLadder(_loc_7, _loc_11, _loc_8));
                        _loc_5[_loc_8] = true;
                    }
                }
            }
            if (_loc_6.length == 1)
            {
                _loc_12 = _loc_6[0];
            }
            else if (_loc_6.length > 1)
            {
                _loc_12 = new CompositePhysicalUpdater(param1, _loc_6);
            }
            return _loc_12;
        }// end function

        public function createBezier(param1:Object, param2:Object, param3:Object, param4:Object) : IUpdater
        {
            var _loc_8:String = null;
            var _loc_9:Object = null;
            var _loc_10:Boolean = false;
            var _loc_11:Array = null;
            var _loc_12:uint = 0;
            var _loc_13:uint = 0;
            var _loc_14:IUpdater = null;
            var _loc_15:IUpdater = null;
            var _loc_5:* = new Dictionary();
            var _loc_6:* = new Vector.<IUpdater>;
            var _loc_7:* = new BezierUpdater();
            new BezierUpdater().target = param1;
            _loc_6.push(_loc_7);
            if (param3 != null)
            {
                for (_loc_8 in param3)
                {
                    
                    var _loc_18:* = param3[_loc_8];
                    _loc_9 = param3[_loc_8];
                    if (_loc_18 is Number)
                    {
                        var _loc_18:* = /^\$/.test(_loc_8);
                        _loc_10 = /^\$/.test(_loc_8);
                        if (_loc_18)
                        {
                            _loc_8 = _loc_8.substr(1);
                        }
                        _loc_7.setSourceValue(_loc_8, Number(_loc_9), _loc_10);
                        continue;
                    }
                    if (!_loc_5[_loc_8])
                    {
                        _loc_14 = this.createBezier(_loc_7.getObject(_loc_8), param2 != null ? (param2[_loc_8]) : (null), _loc_9, param4 != null ? (param4[_loc_8]) : (null));
                        _loc_6.push(new UpdaterLadder(_loc_7, _loc_14, _loc_8));
                        _loc_5[_loc_8] = true;
                    }
                }
            }
            if (param2 != null)
            {
                for (_loc_8 in param2)
                {
                    
                    var _loc_18:* = param2[_loc_8];
                    _loc_9 = param2[_loc_8];
                    if (_loc_18 is Number)
                    {
                        var _loc_18:* = /^\$/.test(_loc_8);
                        _loc_10 = /^\$/.test(_loc_8);
                        if (_loc_18)
                        {
                            _loc_8 = _loc_8.substr(1);
                        }
                        _loc_7.setDestinationValue(_loc_8, Number(_loc_9), _loc_10);
                        continue;
                    }
                    if (!_loc_5[_loc_8])
                    {
                        _loc_14 = this.createBezier(_loc_7.getObject(_loc_8), null, param3 != null ? (param3[_loc_8]) : (null), param4 != null ? (param4[_loc_8]) : (null));
                        _loc_6.push(new UpdaterLadder(_loc_7, _loc_14, _loc_8));
                        _loc_5[_loc_8] = true;
                    }
                }
            }
            if (param4 != null)
            {
                for (_loc_8 in param4)
                {
                    
                    var _loc_18:* = param4[_loc_8];
                    _loc_9 = param4[_loc_8];
                    if (_loc_18 is Number)
                    {
                        _loc_9 = [_loc_9];
                    }
                    if (_loc_9 is Array)
                    {
                        var _loc_18:* = /^\$/.test(_loc_8);
                        _loc_10 = /^\$/.test(_loc_8);
                        if (_loc_18)
                        {
                            _loc_8 = _loc_8.substr(1);
                        }
                        _loc_11 = _loc_9 as Array;
                        _loc_12 = _loc_11.length;
                        _loc_13 = 0;
                        while (_loc_13 < _loc_12)
                        {
                            
                            _loc_7.addControlPoint(_loc_8, _loc_11[_loc_13], _loc_10);
                            _loc_13 = _loc_13 + 1;
                        }
                        continue;
                    }
                    if (!_loc_5[_loc_8])
                    {
                        _loc_14 = this.createBezier(_loc_7.getObject(_loc_8), param2 != null ? (param2[_loc_8]) : (null), param3 != null ? (param3[_loc_8]) : (null), _loc_9);
                        _loc_6.push(new UpdaterLadder(_loc_7, _loc_14, _loc_8));
                        _loc_5[_loc_8] = true;
                    }
                }
            }
            if (_loc_6.length == 1)
            {
                _loc_15 = _loc_6[0];
            }
            else if (_loc_6.length > 1)
            {
                _loc_15 = new CompositeUpdater(param1, _loc_6);
            }
            return _loc_15;
        }// end function

        public function create(param1:Object, param2:Object, param3:Object) : IUpdater
        {
            var _loc_4:Dictionary = null;
            var _loc_5:Vector.<IUpdater> = null;
            var _loc_6:String = null;
            var _loc_7:Object = null;
            var _loc_8:Boolean = false;
            var _loc_9:IUpdater = null;
            var _loc_10:IUpdater = null;
            var _loc_11:IUpdater = null;
            var _loc_12:* = undefined;
            if (this._poolIndex > 0)
            {
                var _loc_13:String = this;
                var _loc_14:* = this._poolIndex - 1;
                _loc_13._poolIndex = _loc_14;
                _loc_4 = this._mapPool[this._poolIndex];
                _loc_5 = this._listPool[this._poolIndex];
            }
            else
            {
                _loc_4 = new Dictionary();
                _loc_5 = new Vector.<IUpdater>;
            }
            if (param3 != null)
            {
                for (_loc_6 in param3)
                {
                    
                    var _loc_15:* = param3[_loc_6];
                    _loc_7 = param3[_loc_6];
                    if (_loc_15 is Number)
                    {
                        var _loc_15:* = /^\$/.test(_loc_6);
                        _loc_8 = /^\$/.test(_loc_6);
                        if (_loc_15)
                        {
                            _loc_6 = _loc_6.substr(1);
                        }
                        this.getUpdaterFor(param1, _loc_6, _loc_4, _loc_5).setSourceValue(_loc_6, Number(_loc_7), _loc_8);
                        continue;
                    }
                    _loc_9 = this.getUpdaterFor(param1, _loc_6, _loc_4, _loc_5);
                    _loc_10 = this.create(_loc_9.getObject(_loc_6), param2 != null ? (param2[_loc_6]) : (null), _loc_7);
                    _loc_5.push(new UpdaterLadder(_loc_9, _loc_10, _loc_6));
                }
            }
            if (param2 != null)
            {
                for (_loc_6 in param2)
                {
                    
                    var _loc_15:* = param2[_loc_6];
                    _loc_7 = param2[_loc_6];
                    if (_loc_15 is Number)
                    {
                        var _loc_15:* = /^\$/.test(_loc_6);
                        _loc_8 = /^\$/.test(_loc_6);
                        if (_loc_15)
                        {
                            _loc_6 = _loc_6.substr(1);
                        }
                        this.getUpdaterFor(param1, _loc_6, _loc_4, _loc_5).setDestinationValue(_loc_6, Number(_loc_7), _loc_8);
                        continue;
                    }
                    if (!(param3 != null && _loc_6 in param3))
                    {
                        _loc_9 = this.getUpdaterFor(param1, _loc_6, _loc_4, _loc_5);
                        _loc_10 = this.create(_loc_9.getObject(_loc_6), _loc_7, param3 != null ? (param3[_loc_6]) : (null));
                        _loc_5.push(new UpdaterLadder(_loc_9, _loc_10, _loc_6));
                    }
                }
            }
            if (_loc_5.length == 1)
            {
                _loc_11 = _loc_5[0];
            }
            else if (_loc_5.length > 1)
            {
                _loc_11 = new CompositeUpdater(param1, _loc_5);
            }
            for (_loc_12 in _loc_4)
            {
                
                delete _loc_4[_loc_12];
            }
            _loc_5.length = 0;
            this._mapPool[this._poolIndex] = _loc_4;
            this._listPool[this._poolIndex] = _loc_5;
            var _loc_13:String = this;
            var _loc_14:* = this._poolIndex + 1;
            _loc_13._poolIndex = _loc_14;
            return _loc_11;
        }// end function

    }
}
