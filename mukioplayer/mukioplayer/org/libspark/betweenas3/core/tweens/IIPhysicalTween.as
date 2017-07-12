package org.libspark.betweenas3.core.tweens
{
    import org.libspark.betweenas3.core.updaters.*;

    public interface IIPhysicalTween extends IObjectTween, IITween
    {

        public function IIPhysicalTween();

        function get updater() : IPhysicalUpdater;

        function set updater(param1:IPhysicalUpdater) : void;

    }
}
