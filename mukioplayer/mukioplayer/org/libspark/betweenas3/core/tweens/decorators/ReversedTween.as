package org.libspark.betweenas3.core.tweens.decorators
{
    import org.libspark.betweenas3.core.tweens.*;

    public class ReversedTween extends TweenDecorator
    {

        public function ReversedTween(param1:IITween, param2:Number)
        {
            super(param1, param2);
            _duration = param1.duration;
            return;
        }// end function

        override protected function newInstance() : AbstractTween
        {
            return new ReversedTween(_baseTween.clone() as IITween, 0);
        }// end function

        override protected function internalUpdate(param1:Number) : void
        {
            _baseTween.update(_duration - param1);
            return;
        }// end function

    }
}
