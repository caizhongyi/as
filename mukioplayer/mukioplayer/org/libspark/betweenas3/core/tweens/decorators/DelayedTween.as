package org.libspark.betweenas3.core.tweens.decorators
{
    import org.libspark.betweenas3.core.tweens.*;

    public class DelayedTween extends TweenDecorator
    {
        private var _postDelay:Number;
        private var _preDelay:Number;

        public function DelayedTween(param1:IITween, param2:Number, param3:Number)
        {
            super(param1, 0);
            _duration = param2 + param1.duration + param3;
            this._preDelay = param2;
            this._postDelay = param3;
            return;
        }// end function

        public function get preDelay() : Number
        {
            return this._preDelay;
        }// end function

        override protected function newInstance() : AbstractTween
        {
            return new DelayedTween(_baseTween.clone() as IITween, this._preDelay, this._postDelay);
        }// end function

        override protected function internalUpdate(param1:Number) : void
        {
            _baseTween.update(param1 - this._preDelay);
            return;
        }// end function

        public function get postDelay() : Number
        {
            return this._postDelay;
        }// end function

    }
}
