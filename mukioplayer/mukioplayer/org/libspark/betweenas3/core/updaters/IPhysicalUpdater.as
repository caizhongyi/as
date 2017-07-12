package org.libspark.betweenas3.core.updaters
{
    import org.libspark.betweenas3.core.easing.*;

    public interface IPhysicalUpdater extends IUpdater
    {

        public function IPhysicalUpdater();

        function get easing() : IPhysicalEasing;

        function get duration() : Number;

        function set easing(param1:IPhysicalEasing) : void;

    }
}
