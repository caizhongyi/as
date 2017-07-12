package com.jeroenwijering.utils
{

    public class Strings extends Object
    {

        public function Strings()
        {
            return;
        }// end function

        public static function serialize(param1:String) : Object
        {
            if (param1 == null)
            {
                return null;
            }
            if (param1 == "true")
            {
                return true;
            }
            if (param1 == "false")
            {
                return false;
            }
            if (isNaN(Number(param1)) || param1.length > 5)
            {
                return param1;
            }
            return Number(param1);
        }// end function

        public static function seconds(param1:String) : Number
        {
            param1 = param1.replace(",", ".");
            var _loc_2:* = param1.split(":");
            var _loc_3:Number = 0;
            if (param1.substr(-1) == "s")
            {
                _loc_3 = Number(param1.substr(0, (param1.length - 1)));
            }
            else if (param1.substr(-1) == "m")
            {
                _loc_3 = Number(param1.substr(0, (param1.length - 1))) * 60;
            }
            else if (param1.substr(-1) == "h")
            {
                _loc_3 = Number(param1.substr(0, (param1.length - 1))) * 3600;
            }
            else if (_loc_2.length > 1)
            {
                _loc_3 = Number(_loc_2[(_loc_2.length - 1)]);
                _loc_3 = _loc_3 + Number(_loc_2[_loc_2.length - 2]) * 60;
                if (_loc_2.length == 3)
                {
                    _loc_3 = _loc_3 + Number(_loc_2[_loc_2.length - 3]) * 3600;
                }
            }
            else
            {
                _loc_3 = Number(param1);
            }
            return _loc_3;
        }// end function

        public static function color(param1:int) : String
        {
            var _loc_2:* = param1.toString(16).length;
            var _loc_3:String = "";
            if (_loc_2 < 6)
            {
                _loc_3 = "00000".substr(0, 6 - _loc_2);
            }
            return "#" + _loc_3 + param1.toString(16);
        }// end function

        public static function digits(param1:Number) : String
        {
            var _loc_2:* = Math.floor(param1 / 60);
            var _loc_3:* = Math.floor(param1 % 60);
            var _loc_4:* = Strings.zero(_loc_2) + ":" + Strings.zero(_loc_3);
            return Strings.zero(_loc_2) + ":" + Strings.zero(_loc_3);
        }// end function

        public static function zero(param1:Number) : String
        {
            if (param1 < 10)
            {
                return "0" + param1;
            }
            return "" + param1;
        }// end function

        public static function cut(param1:String, param2:Number = 17) : String
        {
            var _loc_3:* = param1.split("\n");
            param1 = _loc_3.join("");
            _loc_3 = param1.split("\r");
            param1 = _loc_3.join("");
            if (param1.length <= param2)
            {
                return param1;
            }
            return param1.substr(0, param2) + "...";
        }// end function

        public static function decode(param1:String) : String
        {
            if (param1.indexOf("asfunction") == -1)
            {
                return unescape(param1);
            }
            return "";
        }// end function

        public static function parseFlashvars(param1:String) : Object
        {
            var _loc_5:Array = null;
            var _loc_2:* = param1.split("&");
            if (_loc_2.length == 1)
            {
                _loc_2 = param1.split(" ");
            }
            var _loc_3:Object = {};
            var _loc_4:int = 0;
            while (_loc_4 < _loc_2.length)
            {
                
                trace("arr[i] : " + _loc_2[_loc_4]);
                _loc_5 = String(_loc_2[_loc_4]).split("=");
                if (_loc_5.length == 2)
                {
                    _loc_3[_loc_5[0]] = _loc_5[1];
                    trace("brr[0] : " + _loc_5[0]);
                    trace("brr[1] : " + _loc_5[1]);
                }
                _loc_4++;
            }
            return _loc_3;
        }// end function

        public static function strWidth(param1:String, param2:Number) : Number
        {
            var str:* = param1;
            var size:* = param2;
            var arr:* = str.split(/(\r|\n)/g);
            var brr:* = arr.map(function (param1, param2:int, param3:Array) : Object
            {
                return {len:String(param1).length};
            }// end function
            );
            brr.sortOn("len", Array.NUMERIC);
            return brr[(brr.length - 1)].len * size;
        }// end function

        public static function innerSize(param1:Number) : Number
        {
            return param1;
        }// end function

        public static function strip(param1:String) : String
        {
            var _loc_4:Number = NaN;
            var _loc_2:* = param1.split("\n");
            param1 = _loc_2.join("");
            _loc_2 = param1.split("\r");
            param1 = _loc_2.join("");
            var _loc_3:* = param1.indexOf("<");
            while (_loc_3 != -1)
            {
                
                _loc_4 = param1.indexOf(">", (_loc_3 + 1));
                if (_loc_4 == -1)
                {
                    _loc_4 = param1.length - 1;
                    ;
                }
                param1 = param1.substr(0, _loc_3) + " " + param1.substr((_loc_4 + 1), param1.length);
                _loc_3 = param1.indexOf("<", _loc_3);
            }
            return param1;
        }// end function

        public static function innerSize2(param1:Number) : Number
        {
            var _loc_2:int = 538;
            switch(param1)
            {
                case 10:
                {
                    return _loc_2 / 36;
                }
                case 15:
                {
                    return _loc_2 / 28;
                }
                case 25:
                {
                    return _loc_2 / 20;
                }
                case 37:
                {
                    return _loc_2 / 14;
                }
                default:
                {
                    trace("Size default : ");
                    return 0.8763 * param1 + 5.6904;
                    break;
                }
            }
        }// end function

        public static function date(param1:Date = null) : String
        {
            if (param1 == null)
            {
                param1 = new Date();
            }
            return param1.getFullYear() + "-" + Strings.zero((param1.getMonth() + 1)) + "-" + Strings.zero(param1.getDate()) + " " + Strings.zero(param1.getHours()) + ":" + Strings.zero(param1.getMinutes()) + ":" + Strings.zero(param1.getSeconds());
        }// end function

        public static function strHeight(param1:String, param2:Number) : Number
        {
            var _loc_3:* = param1.split("\r").length;
            return _loc_3 * param2;
        }// end function

    }
}
