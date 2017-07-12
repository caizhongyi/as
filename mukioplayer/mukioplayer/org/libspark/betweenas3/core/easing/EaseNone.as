package org.libspark.betweenas3.core.easing
{

    public class EaseNone extends Object implements IEasing
    {

        public function EaseNone()
        {
            return;
        }// end function

        public function calculate(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            return param3 * param1 / param4 + param2;
        }// end function

    }
}
