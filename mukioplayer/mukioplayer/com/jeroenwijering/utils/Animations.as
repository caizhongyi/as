package com.jeroenwijering.utils
{
    import flash.display.*;
    import flash.events.*;

    public class Animations extends Object
    {

        public function Animations()
        {
            return;
        }// end function

        public static function fade(param1:MovieClip, param2:Number = 1, param3:Number = 0.25) : void
        {
            if (param1.alpha > param2)
            {
                param1.spd = -Math.abs(param3);
            }
            else
            {
                param1.spd = Math.abs(param3);
            }
            param1.end = param2;
            param1.addEventListener(Event.ENTER_FRAME, fadeHandler);
            return;
        }// end function

        private static function fadeHandler(event:Event) : void
        {
            var _loc_2:* = MovieClip(event.target);
            if (_loc_2.alpha >= _loc_2.end - _loc_2.spd && _loc_2.spd > 0 || _loc_2.alpha <= _loc_2.end + _loc_2.spd && _loc_2.spd < 0)
            {
                _loc_2.removeEventListener(Event.ENTER_FRAME, fadeHandler);
                _loc_2.alpha = _loc_2.end;
                if (_loc_2.end == 0)
                {
                    _loc_2.visible = false;
                }
            }
            else
            {
                _loc_2.visible = true;
                _loc_2.alpha = _loc_2.alpha + _loc_2.spd;
            }
            return;
        }// end function

        private static function writeHandler(event:Event) : void
        {
            var _loc_2:* = MovieClip(event.target);
            var _loc_3:* = Math.floor((_loc_2.str.length - _loc_2.tf.text.length) / _loc_2.spd);
            _loc_2.tf.text = _loc_2.str.substr(0, _loc_2.str.length - _loc_3);
            if (_loc_2.tf.text == _loc_2.str)
            {
                _loc_2.tf.htmlText = _loc_2.str;
                _loc_2.removeEventListener(Event.ENTER_FRAME, easeHandler);
            }
            return;
        }// end function

        private static function easeHandler(event:Event) : void
        {
            var _loc_2:* = MovieClip(event.target);
            if (Math.abs(_loc_2.x - _loc_2.xps) < 1 && Math.abs(_loc_2.y - _loc_2.yps) < 1)
            {
                _loc_2.removeEventListener(Event.ENTER_FRAME, easeHandler);
                _loc_2.x = _loc_2.xps;
                _loc_2.y = _loc_2.yps;
            }
            else
            {
                _loc_2.x = _loc_2.xps - (_loc_2.xps - _loc_2.x) / _loc_2.spd;
                _loc_2.y = _loc_2.yps - (_loc_2.yps - _loc_2.y) / _loc_2.spd;
            }
            return;
        }// end function

        public static function ease(param1:MovieClip, param2:Number, param3:Number, param4:Number = 2) : void
        {
            if (!param2)
            {
                param1.xps = param1.x;
            }
            else
            {
                param1.xps = param2;
            }
            if (!param3)
            {
                param1.yps = param1.y;
            }
            else
            {
                param1.yps = param3;
            }
            param1.spd = param4;
            param1.addEventListener(Event.ENTER_FRAME, easeHandler);
            return;
        }// end function

        public static function write(param1:MovieClip, param2:String, param3:Number = 1.5) : void
        {
            param1.str = param2;
            param1.spd = param3;
            param1.tf.text = "";
            param1.addEventListener(Event.ENTER_FRAME, writeHandler);
            return;
        }// end function

    }
}
