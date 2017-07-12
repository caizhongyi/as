package org.libspark.betweenas3.easing
{
    import org.libspark.betweenas3.core.easing.*;

    public class Physical extends Object
    {
        private static var _defaultFrameRate:Number = 30;

        public function Physical()
        {
            return;
        }// end function

        public static function uniform(param1:Number = 10, param2:Number = NaN) : IPhysicalEasing
        {
            return new PhysicalUniform(param1, isNaN(param2) ? (_defaultFrameRate) : (param2));
        }// end function

        public static function exponential(param1:Number = 0.2, param2:Number = 0.0001, param3:Number = NaN) : IPhysicalEasing
        {
            return new PhysicalExponential(param1, param2, isNaN(param3) ? (_defaultFrameRate) : (param3));
        }// end function

        public static function set defaultFrameRate(param1:Number) : void
        {
            _defaultFrameRate = param1;
            return;
        }// end function

        public static function get defaultFrameRate() : Number
        {
            return _defaultFrameRate;
        }// end function

        public static function accelerate(param1:Number = 1, param2:Number = 0, param3:Number = NaN) : IPhysicalEasing
        {
            return new PhysicalAccelerate(param2, param1, isNaN(param3) ? (_defaultFrameRate) : (param3));
        }// end function

    }
}
