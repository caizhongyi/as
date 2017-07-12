package org.libspark.betweenas3.core.easing
{

    public class QuadraticEaseOut extends Object implements IEasing
    {

        public function QuadraticEaseOut()
        {
            return;
        }// end function

        public function calculate(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            var _loc_5:* = param1 / param4;
            param1 = param1 / param4;
            return (-param3) * _loc_5 * (param1 - 2) + param2;
        }// end function

    }
}
