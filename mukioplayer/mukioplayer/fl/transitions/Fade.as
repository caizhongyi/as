package fl.transitions
{
    import flash.display.*;

    public class Fade extends Transition
    {
        protected var _alphaFinal:Number;

        public function Fade(param1:MovieClip, param2:Object, param3:TransitionManager)
        {
            super(param1, param2, param3);
            this._alphaFinal = this.manager.contentAppearance.alpha;
            return;
        }// end function

        override public function get type() : Class
        {
            return Fade;
        }// end function

        override protected function _render(param1:Number) : void
        {
            this._content.alpha = this._alphaFinal * param1;
            return;
        }// end function

    }
}
