package org.libspark.betweenas3.core.ticker
{

    public class TickerListener extends Object
    {
        public var prevListener:TickerListener = null;
        public var nextListener:TickerListener = null;

        public function TickerListener()
        {
            return;
        }// end function

        public function tick(param1:Number) : Boolean
        {
            return false;
        }// end function

    }
}
