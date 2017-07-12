package org.libspark.betweenas3.core.tweens
{
    import org.libspark.betweenas3.core.ticker.*;
    import org.libspark.betweenas3.core.updaters.*;

    public class PhysicalTween extends AbstractTween implements IIPhysicalTween
    {
        protected var _updater:IPhysicalUpdater;

        public function PhysicalTween(param1:ITicker)
        {
            super(param1, 0);
            return;
        }// end function

        public function get updater() : IPhysicalUpdater
        {
            return this._updater;
        }// end function

        public function set updater(param1:IPhysicalUpdater) : void
        {
            this._updater = param1;
            if (this._updater != null)
            {
                _duration = this._updater.duration;
            }
            return;
        }// end function

        override protected function newInstance() : AbstractTween
        {
            return new PhysicalTween(_ticker);
        }// end function

        override protected function internalUpdate(param1:Number) : void
        {
            this._updater.update(param1);
            return;
        }// end function

        public function get target() : Object
        {
            return this._updater != null ? (this._updater.target) : (null);
        }// end function

        override protected function copyFrom(param1:AbstractTween) : void
        {
            super.copyFrom(param1);
            var _loc_2:* = param1 as PhysicalTween;
            this._updater = _loc_2._updater.clone() as IPhysicalUpdater;
            return;
        }// end function

    }
}
