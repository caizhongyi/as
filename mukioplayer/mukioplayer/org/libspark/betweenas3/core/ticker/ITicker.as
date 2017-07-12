package org.libspark.betweenas3.core.ticker
{

    public interface ITicker
    {

        public function ITicker();

        function stop() : void;

        function start() : void;

        function removeTickerListener(param1:TickerListener) : void;

        function get time() : Number;

        function addTickerListener(param1:TickerListener) : void;

    }
}
