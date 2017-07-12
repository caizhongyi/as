package org.libspark.betweenas3.core.tweens.groups
{
    import __AS3__.vec.*;
    import org.libspark.betweenas3.core.ticker.*;
    import org.libspark.betweenas3.core.tweens.*;
    import org.libspark.betweenas3.tweens.*;

    public class SerialTween extends AbstractTween implements IITweenGroup
    {
        private var _a:IITween;
        private var _targets:Vector.<IITween>;
        private var _c:IITween;
        private var _d:IITween;
        private var _lastTime:Number = 0;
        private var _b:IITween;

        public function SerialTween(param1:Array, param2:ITicker, param3:Number)
        {
            var _loc_4:uint = 0;
            var _loc_5:uint = 0;
            var _loc_6:IITween = null;
            super(param2, param3);
            _loc_4 = param1.length;
            _duration = 0;
            if (_loc_4 > 0)
            {
                this._a = param1[0] as IITween;
                _duration = _duration + this._a.duration;
                if (_loc_4 > 1)
                {
                    this._b = param1[1] as IITween;
                    _duration = _duration + this._b.duration;
                    if (_loc_4 > 2)
                    {
                        this._c = param1[2] as IITween;
                        _duration = _duration + this._c.duration;
                        if (_loc_4 > 3)
                        {
                            this._d = param1[3] as IITween;
                            _duration = _duration + this._d.duration;
                            if (_loc_4 > 4)
                            {
                                this._targets = new Vector.<IITween>(_loc_4 - 4, true);
                                _loc_5 = 4;
                                while (_loc_5 < _loc_4)
                                {
                                    
                                    _loc_6 = param1[_loc_5] as IITween;
                                    this._targets[_loc_5 - 4] = _loc_6;
                                    _duration = _duration + _loc_6.duration;
                                    _loc_5 = _loc_5 + 1;
                                }
                            }
                        }
                    }
                }
            }
            return;
        }// end function

        public function getTweenAt(param1:int) : ITween
        {
            if (param1 < 0)
            {
                return null;
            }
            if (param1 == 0)
            {
                return this._a;
            }
            if (param1 == 1)
            {
                return this._b;
            }
            if (param1 == 2)
            {
                return this._c;
            }
            if (param1 == 3)
            {
                return this._d;
            }
            if (this._targets != null)
            {
                if (param1 - 4 < this._targets.length)
                {
                    return this._targets[param1 - 4];
                }
            }
            return null;
        }// end function

        override protected function internalUpdate(param1:Number) : void
        {
            var _loc_5:uint = 0;
            var _loc_6:int = 0;
            var _loc_7:IITween = null;
            var _loc_2:Number = 0;
            var _loc_3:Number = 0;
            var _loc_4:* = this._lastTime;
            if (param1 - _loc_4 >= 0)
            {
                if (this._a != null)
                {
                    var _loc_8:* = _loc_2 + this._a.duration;
                    _loc_2 = _loc_2 + this._a.duration;
                    if (_loc_4 <= _loc_8 && _loc_3 <= param1)
                    {
                        this._a.update(param1 - _loc_3);
                    }
                    _loc_3 = _loc_2;
                    if (this._b != null)
                    {
                        var _loc_8:* = _loc_2 + this._b.duration;
                        _loc_2 = _loc_2 + this._b.duration;
                        if (_loc_4 <= _loc_8 && _loc_3 <= param1)
                        {
                            this._b.update(param1 - _loc_3);
                        }
                        _loc_3 = _loc_2;
                        if (this._c != null)
                        {
                            var _loc_8:* = _loc_2 + this._c.duration;
                            _loc_2 = _loc_2 + this._c.duration;
                            if (_loc_4 <= _loc_8 && _loc_3 <= param1)
                            {
                                this._c.update(param1 - _loc_3);
                            }
                            _loc_3 = _loc_2;
                            if (this._d != null)
                            {
                                var _loc_8:* = _loc_2 + this._d.duration;
                                _loc_2 = _loc_2 + this._d.duration;
                                if (_loc_4 <= _loc_8 && _loc_3 <= param1)
                                {
                                    this._d.update(param1 - _loc_3);
                                }
                                _loc_3 = _loc_2;
                                if (this._targets != null)
                                {
                                    _loc_5 = this._targets.length;
                                    _loc_6 = 0;
                                    while (_loc_6 < _loc_5)
                                    {
                                        
                                        _loc_7 = this._targets[_loc_6];
                                        var _loc_8:* = _loc_2 + _loc_7.duration;
                                        _loc_2 = _loc_2 + _loc_7.duration;
                                        if (_loc_4 <= _loc_8 && _loc_3 <= param1)
                                        {
                                            _loc_7.update(param1 - _loc_3);
                                        }
                                        _loc_3 = _loc_2;
                                        _loc_6++;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                _loc_2 = _duration;
                _loc_3 = _loc_2;
                if (this._targets != null)
                {
                    _loc_6 = this._targets.length - 1;
                    while (_loc_6 >= 0)
                    {
                        
                        _loc_7 = this._targets[_loc_6];
                        var _loc_8:* = _loc_2 - _loc_7.duration;
                        _loc_2 = _loc_2 - _loc_7.duration;
                        if (_loc_4 >= _loc_8 && _loc_3 >= param1)
                        {
                            _loc_7.update(param1 - _loc_2);
                        }
                        _loc_3 = _loc_2;
                        _loc_6 = _loc_6 - 1;
                    }
                }
                if (this._d != null)
                {
                    var _loc_8:* = _loc_2 - this._d.duration;
                    _loc_2 = _loc_2 - this._d.duration;
                    if (_loc_4 >= _loc_8 && _loc_3 >= param1)
                    {
                        this._d.update(param1 - _loc_2);
                    }
                    _loc_3 = _loc_2;
                }
                if (this._c != null)
                {
                    var _loc_8:* = _loc_2 - this._c.duration;
                    _loc_2 = _loc_2 - this._c.duration;
                    if (_loc_4 >= _loc_8 && _loc_3 >= param1)
                    {
                        this._c.update(param1 - _loc_2);
                    }
                    _loc_3 = _loc_2;
                }
                if (this._b != null)
                {
                    var _loc_8:* = _loc_2 - this._b.duration;
                    _loc_2 = _loc_2 - this._b.duration;
                    if (_loc_4 >= _loc_8 && _loc_3 >= param1)
                    {
                        this._b.update(param1 - _loc_2);
                    }
                    _loc_3 = _loc_2;
                }
                if (this._a != null)
                {
                    var _loc_8:* = _loc_2 - this._a.duration;
                    _loc_2 = _loc_2 - this._a.duration;
                    if (_loc_4 >= _loc_8 && _loc_3 >= param1)
                    {
                        this._a.update(param1 - _loc_2);
                    }
                    _loc_3 = _loc_2;
                }
            }
            this._lastTime = param1;
            return;
        }// end function

        override protected function newInstance() : AbstractTween
        {
            var _loc_2:Vector.<IITween> = null;
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            var _loc_1:Array = [];
            if (this._a != null)
            {
                _loc_1.push(this._a.clone());
            }
            if (this._b != null)
            {
                _loc_1.push(this._b.clone());
            }
            if (this._c != null)
            {
                _loc_1.push(this._c.clone());
            }
            if (this._d != null)
            {
                _loc_1.push(this._d.clone());
            }
            if (this._targets != null)
            {
                _loc_2 = this._targets;
                _loc_3 = _loc_2.length;
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    _loc_1.push(_loc_2[_loc_4].clone());
                    _loc_4 = _loc_4 + 1;
                }
            }
            return new SerialTween(_loc_1, ticker, 0);
        }// end function

        public function getTweenIndex(param1:ITween) : int
        {
            var _loc_2:int = 0;
            if (param1 == null)
            {
                return -1;
            }
            if (this._a == param1)
            {
                return 0;
            }
            if (this._b == param1)
            {
                return 1;
            }
            if (this._c == param1)
            {
                return 2;
            }
            if (this._d == param1)
            {
                return 3;
            }
            if (this._targets != null)
            {
                _loc_2 = this._targets.indexOf(param1 as IITween);
                if (_loc_2 != -1)
                {
                    return _loc_2 + 4;
                }
            }
            return -1;
        }// end function

        public function contains(param1:ITween) : Boolean
        {
            if (param1 == null)
            {
                return false;
            }
            if (this._a == param1)
            {
                return true;
            }
            if (this._b == param1)
            {
                return true;
            }
            if (this._c == param1)
            {
                return true;
            }
            if (this._d == param1)
            {
                return true;
            }
            if (this._targets != null)
            {
                return this._targets.indexOf(param1 as IITween) != -1;
            }
            return false;
        }// end function

    }
}
