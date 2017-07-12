package org.libspark.betweenas3.core.easing
{

    public class PhysicalAccelerate extends Object implements IPhysicalEasing
    {
        private var _a:Number;
        private var _fps:Number;
        private var _iv:Number;

        public function PhysicalAccelerate(param1:Number, param2:Number, param3:Number)
        {
            this._iv = param1;
            this._a = param2;
            this._fps = param3;
            return;
        }// end function

        public function getDuration(param1:Number, param2:Number) : Number
        {
            var _loc_3:* = param2 < 0 ? (-this._iv) : (this._iv);
            var _loc_4:* = param2 < 0 ? (-this._a) : (this._a);
            return (-_loc_3 + Math.sqrt(_loc_3 * _loc_3 - 4 * (_loc_4 / 2) * (-param2))) / (2 * (_loc_4 / 2)) * (1 / this._fps);
        }// end function

        public function calculate(param1:Number, param2:Number, param3:Number) : Number
        {
            var _loc_4:* = param3 < 0 ? (-1) : (1);
            var _loc_5:* = param1 / (1 / this._fps);
            return param2 + _loc_4 * this._iv * _loc_5 + _loc_4 * this._a * _loc_5 * _loc_5 / 2;
        }// end function

    }
}
