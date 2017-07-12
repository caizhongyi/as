package org.libspark.betweenas3.core.easing
{

    public class QuadraticEaseInOut extends Object implements IEasing
    {

        public function QuadraticEaseInOut()
        {
            return;
        }// end function

        public function calculate(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            var _loc_5:* = param1 / (param4 / 2);
            param1 = param1 / (param4 / 2);
            if (_loc_5 < 1)
            {
                return param3 / 2 * param1 * param1 + param2;
            }
            return (-param3) / 2 * (--param1 * (--param1 - 2) - 1) + param2;
        }// end function

    }
}
