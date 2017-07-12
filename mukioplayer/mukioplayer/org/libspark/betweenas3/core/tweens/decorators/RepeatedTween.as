package org.libspark.betweenas3.core.tweens.decorators
{
    import org.libspark.betweenas3.core.tweens.*;

    public class RepeatedTween extends TweenDecorator
    {
        private var _baseDuration:Number;
        private var _repeatCount:uint;

        public function RepeatedTween(param1:IITween, param2:uint)
        {
            super(param1, 0);
            this._baseDuration = param1.duration;
            this._repeatCount = param2;
            _duration = this._baseDuration * param2;
            return;
        }// end function

        override protected function internalUpdate(param1:Number) : void
        {
            if (param1 >= 0)
            {
                param1 = param1 - (param1 < _duration ? (this._baseDuration * int(param1 / this._baseDuration)) : (_duration - this._baseDuration));
            }
            _baseTween.update(param1);
            return;
        }// end function

        public function get repeatCount() : uint
        {
            return this._repeatCount;
        }// end function

        override protected function newInstance() : AbstractTween
        {
            return new RepeatedTween(_baseTween.clone() as IITween, this.repeatCount);
        }// end function

    }
}
