package org.lala.components
{
    import fl.controls.*;
    import fl.events.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    import org.lala.events.*;

    public class AlphaSlider extends AlphaSliderBackground
    {
        private var sld:Slider;
        private var hdtm:Timer;
        private var _rel:Sprite;

        public function AlphaSlider()
        {
            width = 28;
            height = 78;
            this.sld = new Slider();
            var _loc_2:* = this.sld;
            with (this.sld)
            {
                x = 16;
                y = 10;
                direction = SliderDirection.VERTICAL;
                maximum = 100;
                minimum = 0;
                snapInterval = 5;
                value = 100;
                width = 28;
                height = 63;
                setStyle("thumbUpSkin", circleThum_over);
                setStyle("thumbDownSkin", circleThum_down);
                setStyle("thumbOverSkin", circleThum_up);
                setStyle("thumbDisabledSkin", circleThum_up);
                setStyle("sliderTrackSkin", AlphaSliderBlue_track);
            }
            this.sld.addEventListener(SliderEvent.CHANGE, function (event:SliderEvent) : void
            {
                dispatchEvent(new CommentListViewEvent(CommentListViewEvent.COMMENTALPHA, {value:event.value}));
                return;
            }// end function
            );
            addChild(this.sld);
            this.hdtm = new Timer(500, 1);
            this.hdtm.addEventListener(TimerEvent.TIMER_COMPLETE, this.hideHandler);
            addEventListener(MouseEvent.MOUSE_OVER, function (event:MouseEvent) : void
            {
                show();
                return;
            }// end function
            );
            addEventListener(MouseEvent.MOUSE_OUT, function (event:MouseEvent) : void
            {
                hide();
                return;
            }// end function
            );
            this.hideHandler();
            return;
        }// end function

        override public function get enabled() : Boolean
        {
            return super.enabled;
        }// end function

        public function hide() : void
        {
            this.hdtm.start();
            return;
        }// end function

        private function hideHandler(event:TimerEvent = null) : void
        {
            visible = false;
            return;
        }// end function

        override public function set enabled(param1:Boolean) : void
        {
            super.enabled = param1;
            this.sld.enabled = param1;
            return;
        }// end function

        public function set value(param1:Number) : void
        {
            if (param1 < 0 || param1 > 100)
            {
                return;
            }
            this.sld.value = param1;
            dispatchEvent(new CommentListViewEvent(CommentListViewEvent.COMMENTALPHA, {value:this.sld.value}));
            return;
        }// end function

        public function set rel(param1:Sprite) : void
        {
            this._rel = param1;
            return;
        }// end function

        public function get rel() : Sprite
        {
            return this._rel;
        }// end function

        public function show() : void
        {
            if (this.hdtm.running)
            {
                this.hdtm.stop();
            }
            if (visible)
            {
                return;
            }
            x = this.rel.x - 2;
            y = -78;
            visible = true;
            return;
        }// end function

    }
}
