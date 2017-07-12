package org.libspark.betweenas3.core.tweens
{
    import org.libspark.betweenas3.core.easing.*;
    import org.libspark.betweenas3.core.ticker.*;
    import org.libspark.betweenas3.core.updaters.*;

    public class ObjectTween extends AbstractTween implements IIObjectTween
    {
        protected var _easing:IEasing;
        protected var _updater:IUpdater;

        public function ObjectTween(param1:ITicker)
        {
            super(param1, 0);
            return;
        }// end function

        public function set time(param1:Number) : void
        {
            _duration = param1;
            return;
        }// end function

        override protected function internalUpdate(param1:Number) : void
        {
            var _loc_2:Number = 0;
            if (param1 > 0)
            {
                if (param1 < _duration)
                {
                    _loc_2 = this._easing.calculate(param1, 0, 1, _duration);
                }
                else
                {
                    _loc_2 = 1;
                }
            }
            this._updater.update(_loc_2);
            return;
        }// end function

        public function get updater() : IUpdater
        {
            return this._updater;
        }// end function

        public function get easing() : IEasing
        {
            return this._easing;
        }// end function

        override protected function copyFrom(param1:AbstractTween) : void
        {
            super.copyFrom(param1);
            var _loc_2:* = param1 as ObjectTween;
            this._easing = _loc_2._easing;
            this._updater = _loc_2._updater.clone();
            return;
        }// end function

        override protected function newInstance() : AbstractTween
        {
            return new ObjectTween(_ticker);
        }// end function

        public function set easing(param1:IEasing) : void
        {
            this._easing = param1;
            return;
        }// end function

        public function get target() : Object
        {
            return this._updater != null ? (this._updater.target) : (null);
        }// end function

        public function set updater(param1:IUpdater) : void
        {
            this._updater = param1;
            return;
        }// end function

        public function get time() : Number
        {
            return _duration;
        }// end function

    }
}
