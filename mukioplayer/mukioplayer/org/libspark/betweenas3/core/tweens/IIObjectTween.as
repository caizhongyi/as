package org.libspark.betweenas3.core.tweens
{
    import org.libspark.betweenas3.core.easing.*;
    import org.libspark.betweenas3.core.updaters.*;

    public interface IIObjectTween extends IObjectTween, IITween
    {

        public function IIObjectTween();

        function set updater(param1:IUpdater) : void;

        function set easing(param1:IEasing) : void;

        function get updater() : IUpdater;

        function set time(param1:Number) : void;

        function get easing() : IEasing;

        function get time() : Number;

    }
}
