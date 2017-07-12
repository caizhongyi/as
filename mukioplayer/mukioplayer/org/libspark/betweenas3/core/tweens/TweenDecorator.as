package org.libspark.betweenas3.core.tweens
{

    public class TweenDecorator extends AbstractTween
    {
        protected var _baseTween:IITween;

        public function TweenDecorator(param1:IITween, param2:Number)
        {
            super(param1.ticker, param2);
            this._baseTween = param1;
            _duration = param1.duration;
            return;
        }// end function

        override public function stop() : void
        {
            if (_isPlaying)
            {
                super.stop();
                this._baseTween.fireStop();
            }
            return;
        }// end function

        override protected function internalUpdate(param1:Number) : void
        {
            this._baseTween.update(param1);
            return;
        }// end function

        override public function firePlay() : void
        {
            super.firePlay();
            this._baseTween.firePlay();
            return;
        }// end function

        override public function play() : void
        {
            if (!_isPlaying)
            {
                this._baseTween.firePlay();
                super.play();
            }
            return;
        }// end function

        public function get baseTween() : IITween
        {
            return this._baseTween;
        }// end function

        override public function fireStop() : void
        {
            super.fireStop();
            this._baseTween.fireStop();
            return;
        }// end function

    }
}
