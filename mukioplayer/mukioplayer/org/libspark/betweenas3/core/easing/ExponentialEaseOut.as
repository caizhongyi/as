package org.libspark.betweenas3.core.easing
{

    public class ExponentialEaseOut extends Object implements IEasing
    {

        public function ExponentialEaseOut()
        {
            return;
        }// end function

        public function calculate(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            return param1 == param4 ? (param2 + param3) : (param3 * (1 - Math.pow(2, -10 * param1 / param4)) + param2);
        }// end function

    }
}
