package org.libspark.betweenas3.easing
{
    import org.libspark.betweenas3.core.easing.*;

    public class Quad extends Object
    {
        public static const easeOut:IEasing = new QuadraticEaseOut();
        public static const easeIn:IEasing = new QuadraticEaseIn();
        public static const easeOutIn:IEasing = new QuadraticEaseOutIn();
        public static const easeInOut:IEasing = new QuadraticEaseInOut();

        public function Quad()
        {
            return;
        }// end function

    }
}
