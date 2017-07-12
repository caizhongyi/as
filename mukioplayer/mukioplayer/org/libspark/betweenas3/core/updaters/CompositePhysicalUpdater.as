package org.libspark.betweenas3.core.updaters
{
    import __AS3__.vec.*;
    import org.libspark.betweenas3.core.easing.*;

    public class CompositePhysicalUpdater extends Object implements IPhysicalUpdater
    {
        private var _a:IPhysicalUpdater;
        private var _b:IPhysicalUpdater;
        private var _c:IPhysicalUpdater;
        private var _d:IPhysicalUpdater;
        private var _updaters:Vector.<IPhysicalUpdater>;
        private var _target:Object = null;
        private var _duration:Number = 0;

        public function CompositePhysicalUpdater(param1:Object, param2:Vector.<IPhysicalUpdater>)
        {
            var _loc_4:uint = 0;
            var _loc_5:IPhysicalUpdater = null;
            this._target = param1;
            var _loc_3:* = param2.length;
            if (_loc_3 >= 1)
            {
                this._a = param2[0];
                if (this._duration < this._a.duration)
                {
                    this._duration = this._a.duration;
                }
                if (_loc_3 >= 2)
                {
                    this._b = param2[1];
                    if (this._duration < this._b.duration)
                    {
                        this._duration = this._b.duration;
                    }
                    if (_loc_3 >= 3)
                    {
                        this._c = param2[2];
                        if (this._duration < this._c.duration)
                        {
                            this._duration = this._c.duration;
                        }
                        if (_loc_3 >= 4)
                        {
                            this._d = param2[3];
                            if (this._duration < this._d.duration)
                            {
                                this._duration = this._d.duration;
                            }
                            if (_loc_3 >= 5)
                            {
                                this._updaters = new Vector.<IPhysicalUpdater>(_loc_3 - 4, true);
                                _loc_4 = 4;
                                while (_loc_4 < _loc_3)
                                {
                                    
                                    _loc_5 = param2[_loc_4];
                                    this._updaters[_loc_4 - 4] = _loc_5;
                                    if (this._duration < _loc_5.duration)
                                    {
                                        this._duration = _loc_5.duration;
                                    }
                                    _loc_4 = _loc_4 + 1;
                                }
                            }
                        }
                    }
                }
            }
            return;
        }// end function

        public function setObject(param1:String, param2:Object) : void
        {
            return;
        }// end function

        public function setDestinationValue(param1:String, param2:Number, param3:Boolean = false) : void
        {
            return;
        }// end function

        public function update(param1:Number) : void
        {
            var _loc_2:Vector.<IPhysicalUpdater> = null;
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            if (this._a != null)
            {
                this._a.update(param1);
                if (this._b != null)
                {
                    this._b.update(param1);
                    if (this._c != null)
                    {
                        this._c.update(param1);
                        if (this._d != null)
                        {
                            this._d.update(param1);
                            if (this._updaters != null)
                            {
                                _loc_2 = this._updaters;
                                _loc_3 = _loc_2.length;
                                _loc_4 = 0;
                                while (_loc_4 < _loc_3)
                                {
                                    
                                    _loc_2[_loc_4].update(param1);
                                    _loc_4 = _loc_4 + 1;
                                }
                            }
                        }
                    }
                }
            }
            return;
        }// end function

        public function get target() : Object
        {
            return this._target;
        }// end function

        public function get duration() : Number
        {
            return this._duration;
        }// end function

        public function set easing(param1:IPhysicalEasing) : void
        {
            return;
        }// end function

        public function setSourceValue(param1:String, param2:Number, param3:Boolean = false) : void
        {
            return;
        }// end function

        public function getUpdaterAt(param1:uint) : IPhysicalUpdater
        {
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
            return this._updaters[param1 - 4];
        }// end function

        public function set target(param1:Object) : void
        {
            this._target = param1;
            return;
        }// end function

        public function get easing() : IPhysicalEasing
        {
            return null;
        }// end function

        public function getObject(param1:String) : Object
        {
            return null;
        }// end function

        public function clone() : IUpdater
        {
            var _loc_2:Vector.<IPhysicalUpdater> = null;
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            var _loc_1:* = new Vector.<IPhysicalUpdater>;
            if (this._a != null)
            {
                _loc_1.push(this._a.clone());
                if (this._b != null)
                {
                    _loc_1.push(this._b.clone());
                    if (this._c != null)
                    {
                        _loc_1.push(this._c.clone());
                        if (this._d != null)
                        {
                            _loc_1.push(this._d.clone());
                            if (this._updaters != null)
                            {
                                _loc_2 = this._updaters;
                                _loc_3 = _loc_2.length;
                                _loc_4 = 0;
                                while (_loc_4 < _loc_3)
                                {
                                    
                                    _loc_1.push(_loc_2[_loc_4].clone());
                                    _loc_4 = _loc_4 + 1;
                                }
                            }
                        }
                    }
                }
            }
            return new CompositePhysicalUpdater(this._target, _loc_1);
        }// end function

    }
}
