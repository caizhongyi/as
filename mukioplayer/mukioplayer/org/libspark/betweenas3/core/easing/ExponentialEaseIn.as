package org.libspark.betweenas3.core.easing
{

    public class ExponentialEaseIn extends Object implements IEasing
    {

        public function ExponentialEaseIn()
        {
            return;
        }// end function

        public function calculate(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            return param1 == 0 ? (param2) : (param3 * Math.pow(2, 10 * (param1 / param4 - 1)) + param2);
        }// end function

    }
}
