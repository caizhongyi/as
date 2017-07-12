package com.jeroenwijering.models
{
    import com.jeroenwijering.player.*;
    import com.jeroenwijering.utils.*;
    import flash.display.*;

    public class AbstractModel extends Sprite
    {
        protected var model:Model;
        protected var position:Number;
        protected var item:Object;

        public function AbstractModel(param1:Model) : void
        {
            this.model = param1;
            mouseEnabled = false;
            return;
        }// end function

        public function volume(param1:Number) : void
        {
            return;
        }// end function

        public function stop() : void
        {
            return;
        }// end function

        public function load(param1:Object) : void
        {
            this.item = param1;
            this.position = 0;
            return;
        }// end function

        public function play() : void
        {
            return;
        }// end function

        public function pause() : void
        {
            return;
        }// end function

        public function seek(param1:Number) : void
        {
            this.position = param1;
            return;
        }// end function

        public function resize() : void
        {
            Stretcher.stretch(this, this.model.config["width"], this.model.config["height"], this.model.config["stretching"]);
            return;
        }// end function

    }
}
