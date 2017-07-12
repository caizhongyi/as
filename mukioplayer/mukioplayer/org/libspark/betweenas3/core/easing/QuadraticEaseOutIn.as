package org.libspark.betweenas3.core.easing
{

    public class QuadraticEaseOutIn extends Object implements IEasing
    {

        public function QuadraticEaseOutIn()
        {
            return;
        }// end function

        public function calculate(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            if (param1 < param4 / 2)
            {
                var _loc_5:* = param1 * 2 / param4;
                param1 = param1 * 2 / param4;
                return (-param3 / 2) * _loc_5 * (param1 - 2) + param2;
            }
            var _loc_5:* = (param1 * 2 - param4) / param4;
            param1 = (param1 * 2 - param4) / param4;
            return param3 / 2 * _loc_5 * param1 + (param2 + param3 / 2);
        }// end function

    }
}
