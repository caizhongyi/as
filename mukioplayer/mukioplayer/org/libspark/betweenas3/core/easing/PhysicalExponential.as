package org.libspark.betweenas3.core.easing
{

    public class PhysicalExponential extends Object implements IPhysicalEasing
    {
        private var _th:Number;
        private var _f:Number;
        private var _fps:Number;

        public function PhysicalExponential(param1:Number, param2:Number, param3:Number)
        {
            this._f = param1;
            this._th = param2;
            this._fps = param3;
            return;
        }// end function

        public function getDuration(param1:Number, param2:Number) : Number
        {
            return (Math.log(this._th / param2) / Math.log(1 - this._f) + 1) * (1 / this._fps);
        }// end function

        public function calculate(param1:Number, param2:Number, param3:Number) : Number
        {
            return (-param3) * Math.pow(1 - this._f, param1 / (1 / this._fps) - 1) + (param2 + param3);
        }// end function

    }
}
