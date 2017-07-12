package org.libspark.betweenas3.tweens
{

    public interface ITweenGroup extends ITween
    {

        public function ITweenGroup();

        function getTweenAt(param1:int) : ITween;

        function getTweenIndex(param1:ITween) : int;

        function contains(param1:ITween) : Boolean;

    }
}
