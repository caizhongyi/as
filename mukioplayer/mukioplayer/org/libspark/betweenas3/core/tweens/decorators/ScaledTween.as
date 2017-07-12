package org.libspark.betweenas3.core.tweens.decorators
{
    import org.libspark.betweenas3.core.tweens.*;

    public class ScaledTween extends TweenDecorator
    {
        private var _scale:Number;

        public function ScaledTween(param1:IITween, param2:Number)
        {
            super(param1, 0);
            _duration = param1.duration * param2;
            this._scale = param2;
            return;
        }// end function

        public function get scale() : Number
        {
            return this._scale;
        }// end function

        override protected function newInstance() : AbstractTween
        {
            return new ScaledTween(_baseTween.clone() as IITween, this._scale);
        }// end function

        override protected function internalUpdate(param1:Number) : void
        {
            _baseTween.update(param1 / this.scale);
            return;
        }// end function

    }
}
