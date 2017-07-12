package org.libspark.betweenas3.easing
{
    import org.libspark.betweenas3.core.easing.*;

    public class Expo extends Object
    {
        public static const easeOut:IEasing = new ExponentialEaseOut();
        public static const easeIn:IEasing = new ExponentialEaseIn();
        public static const easeOutIn:IEasing = new ExponentialEaseOutIn();
        public static const easeInOut:IEasing = new ExponentialEaseInOut();

        public function Expo()
        {
            return;
        }// end function

    }
}
