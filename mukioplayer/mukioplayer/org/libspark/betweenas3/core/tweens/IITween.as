package org.libspark.betweenas3.core.tweens
{
    import org.libspark.betweenas3.core.ticker.*;

    public interface IITween extends ITween
    {

        public function IITween();

        function fireStop() : void;

        function firePlay() : void;

        function get ticker() : ITicker;

        function update(param1:Number) : void;

    }
}
