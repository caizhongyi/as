package org.libspark.betweenas3.core.easing
{

    public class PhysicalUniform extends Object implements IPhysicalEasing
    {
        private var _fps:Number;
        private var _v:Number;

        public function PhysicalUniform(param1:Number, param2:Number)
        {
            this._v = param1;
            this._fps = param2;
            return;
        }// end function

        public function calculate(param1:Number, param2:Number, param3:Number) : Number
        {
            return param2 + (param3 < 0 ? (-this._v) : (this._v)) * (param1 / (1 / this._fps));
        }// end function

        public function getDuration(param1:Number, param2:Number) : Number
        {
            return param2 / (param2 < 0 ? (-this._v) : (this._v)) * (1 / this._fps);
        }// end function

    }
}
