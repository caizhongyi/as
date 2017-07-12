package com.jeroenwijering.utils
{

    public class TEA extends Object
    {

        public function TEA()
        {
            return;
        }// end function

        private static function strToChars(param1:String) : Array
        {
            var _loc_2:* = new Array();
            var _loc_3:Number = 0;
            while (_loc_3 < param1.length)
            {
                
                _loc_2.push(param1.charCodeAt(_loc_3));
                _loc_3 = _loc_3 + 1;
            }
            return _loc_2;
        }// end function

        private static function charsToHex(param1:Array) : String
        {
            var _loc_2:* = new String("");
            var _loc_3:* = new Array("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f");
            var _loc_4:Number = 0;
            while (_loc_4 < param1.length)
            {
                
                _loc_2 = _loc_2 + (_loc_3[param1[_loc_4] >> 4] + _loc_3[param1[_loc_4] & 15]);
                _loc_4 = _loc_4 + 1;
            }
            return _loc_2;
        }// end function

        public static function encrypt(param1:String, param2:String) : String
        {
            var _loc_6:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_3:* = charsToLongs(strToChars(param1));
            var _loc_4:* = charsToLongs(strToChars(param2));
            var _loc_5:* = _loc_3.length;
            if (_loc_3.length == 0)
            {
                return "";
            }
            if (_loc_5 == 1)
            {
                _loc_3[++_loc_5] = 0;
            }
            var _loc_7:* = _loc_3[(_loc_5 - 1)];
            var _loc_8:* = _loc_3[0];
            var _loc_9:Number = 2654435769;
            var _loc_12:* = Math.floor(6 + 52 / _loc_5);
            var _loc_13:Number = 0;
            while (_loc_12-- > 0)
            {
                
                _loc_13 = _loc_13 + _loc_9;
                _loc_11 = _loc_13 >>> 2 & 3;
                _loc_6 = 0;
                while (_loc_6 < (_loc_5 - 1))
                {
                    
                    _loc_8 = _loc_3[(_loc_6 + 1)];
                    _loc_10 = (_loc_7 >>> 5 ^ _loc_8 << 2) + (_loc_8 >>> 3 ^ _loc_7 << 4) ^ (_loc_13 ^ _loc_8) + (_loc_4[_loc_6 & 3 ^ _loc_11] ^ _loc_7);
                    var _loc_14:* = _loc_3[_loc_6] + _loc_10;
                    _loc_3[_loc_6] = _loc_3[_loc_6] + _loc_10;
                    _loc_7 = _loc_14;
                    _loc_6 = _loc_6 + 1;
                }
                _loc_8 = _loc_3[0];
                _loc_10 = (_loc_7 >>> 5 ^ _loc_8 << 2) + (_loc_8 >>> 3 ^ _loc_7 << 4) ^ (_loc_13 ^ _loc_8) + (_loc_4[_loc_6 & 3 ^ _loc_11] ^ _loc_7);
                var _loc_14:* = _loc_3[(_loc_5 - 1)] + _loc_10;
                _loc_3[(_loc_5 - 1)] = _loc_3[(_loc_5 - 1)] + _loc_10;
                _loc_7 = _loc_14;
            }
            return charsToHex(longsToChars(_loc_3));
        }// end function

        private static function longToChars(param1:Number) : Array
        {
            var _loc_2:* = new Array();
            _loc_2.push(param1 & 255, param1 >>> 8 & 255, param1 >>> 16 & 255, param1 >>> 24 & 255);
            return _loc_2;
        }// end function

        private static function hexToChars(param1:String) : Array
        {
            var _loc_2:* = new Array();
            var _loc_3:* = param1.substr(0, 2) == "0x" ? (2) : (0);
            while (_loc_3 < param1.length)
            {
                
                _loc_2.push(parseInt(param1.substr(_loc_3, 2), 16));
                _loc_3 = _loc_3 + 2;
            }
            return _loc_2;
        }// end function

        private static function charsToStr(param1:Array) : String
        {
            var _loc_2:* = new String("");
            var _loc_3:Number = 0;
            while (_loc_3 < param1.length)
            {
                
                _loc_2 = _loc_2 + String.fromCharCode(param1[_loc_3]);
                _loc_3 = _loc_3 + 1;
            }
            return _loc_2;
        }// end function

        private static function longsToChars(param1:Array) : Array
        {
            var _loc_2:* = new Array();
            var _loc_3:Number = 0;
            while (_loc_3 < param1.length)
            {
                
                _loc_2.push(param1[_loc_3] & 255, param1[_loc_3] >>> 8 & 255, param1[_loc_3] >>> 16 & 255, param1[_loc_3] >>> 24 & 255);
                _loc_3 = _loc_3 + 1;
            }
            return _loc_2;
        }// end function

        public static function decrypt(param1:String, param2:String) : String
        {
            var _loc_6:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_3:* = charsToLongs(hexToChars(param1));
            var _loc_4:* = charsToLongs(strToChars(param2));
            var _loc_5:* = _loc_3.length;
            if (_loc_3.length == 0)
            {
                return "";
            }
            var _loc_7:* = _loc_3[(_loc_5 - 1)];
            var _loc_8:* = _loc_3[0];
            var _loc_9:Number = 2654435769;
            var _loc_12:* = Math.floor(6 + 52 / _loc_5);
            var _loc_13:* = Math.floor(6 + 52 / _loc_5) * _loc_9;
            while (_loc_13 != 0)
            {
                
                _loc_11 = _loc_13 >>> 2 & 3;
                _loc_6 = _loc_5 - 1;
                while (_loc_6 > 0)
                {
                    
                    _loc_7 = _loc_3[(_loc_6 - 1)];
                    _loc_10 = (_loc_7 >>> 5 ^ _loc_8 << 2) + (_loc_8 >>> 3 ^ _loc_7 << 4) ^ (_loc_13 ^ _loc_8) + (_loc_4[_loc_6 & 3 ^ _loc_11] ^ _loc_7);
                    var _loc_14:* = _loc_3[_loc_6] - _loc_10;
                    _loc_3[_loc_6] = _loc_3[_loc_6] - _loc_10;
                    _loc_8 = _loc_14;
                    _loc_6 = _loc_6 - 1;
                }
                _loc_7 = _loc_3[(_loc_5 - 1)];
                _loc_10 = (_loc_7 >>> 5 ^ _loc_8 << 2) + (_loc_8 >>> 3 ^ _loc_7 << 4) ^ (_loc_13 ^ _loc_8) + (_loc_4[_loc_6 & 3 ^ _loc_11] ^ _loc_7);
                var _loc_14:* = _loc_3[0] - _loc_10;
                _loc_3[0] = _loc_3[0] - _loc_10;
                _loc_8 = _loc_14;
                _loc_13 = _loc_13 - _loc_9;
            }
            return charsToStr(longsToChars(_loc_3));
        }// end function

        private static function charsToLongs(param1:Array) : Array
        {
            var _loc_2:* = new Array(Math.ceil(param1.length / 4));
            var _loc_3:Number = 0;
            while (_loc_3 < _loc_2.length)
            {
                
                _loc_2[_loc_3] = param1[_loc_3 * 4] + (param1[_loc_3 * 4 + 1] << 8) + (param1[_loc_3 * 4 + 2] << 16) + (param1[_loc_3 * 4 + 3] << 24);
                _loc_3 = _loc_3 + 1;
            }
            return _loc_2;
        }// end function

    }
}
