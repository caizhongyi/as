package com.jeroenwijering.utils
{
    import flash.display.*;

    public class Stretcher extends Object
    {
        public static var FILL:String = "fill";
        public static var _16X9:String = "16:9";
        public static var EXACTFIT:String = "exactfit";
        public static var UNIFORM:String = "uniform";
        public static var _4X3:String = "4:3";
        public static var NONE:String = "none";

        public function Stretcher()
        {
            return;
        }// end function

        public static function stretch(param1:DisplayObject, param2:Number, param3:Number, param4:String = "uniform") : void
        {
            var _loc_5:* = param2 / param1.width;
            var _loc_6:* = param3 / param1.height;
            switch(param4.toLowerCase())
            {
                case "16:9":
                {
                    param1.width = param2;
                    param1.height = param2 * 9 / 16;
                    if (param1.height > param3)
                    {
                        param1.width = param3 * 16 / 9;
                        param1.height = param3;
                    }
                    break;
                }
                case "4:3":
                {
                    param1.width = param2;
                    param1.height = param2 * 3 / 4;
                    if (param1.height > param3)
                    {
                        param1.width = param3 * 4 / 3;
                        param1.height = param3;
                    }
                    break;
                }
                case "exactfit":
                {
                    param1.width = param2;
                    param1.height = param3;
                    break;
                }
                case "fill":
                {
                    if (_loc_5 > _loc_6)
                    {
                        param1.width = param1.width * _loc_5;
                        param1.height = param1.height * _loc_5;
                    }
                    else
                    {
                        param1.width = param1.width * _loc_6;
                        param1.height = param1.height * _loc_6;
                    }
                    break;
                }
                case "none":
                {
                    param1.scaleX = 1;
                    param1.scaleY = 1;
                    break;
                }
                case "uniform":
                {
                }
                default:
                {
                    if (_loc_5 > _loc_6)
                    {
                        param1.width = param1.width * _loc_6;
                        param1.height = param1.height * _loc_6;
                    }
                    else
                    {
                        param1.width = param1.width * _loc_5;
                        param1.height = param1.height * _loc_5;
                    }
                    break;
                    break;
                }
            }
            param1.x = Math.round(param2 / 2 - param1.width / 2);
            param1.y = Math.round(param3 / 2 - param1.height / 2);
            param1.width = Math.ceil(param1.width);
            param1.height = Math.ceil(param1.height);
            return;
        }// end function

    }
}
