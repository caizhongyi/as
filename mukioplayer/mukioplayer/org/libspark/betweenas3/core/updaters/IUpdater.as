package org.libspark.betweenas3.core.updaters
{

    public interface IUpdater
    {

        public function IUpdater();

        function setObject(param1:String, param2:Object) : void;

        function set target(param1:Object) : void;

        function setSourceValue(param1:String, param2:Number, param3:Boolean = false) : void;

        function setDestinationValue(param1:String, param2:Number, param3:Boolean = false) : void;

        function get target() : Object;

        function update(param1:Number) : void;

        function getObject(param1:String) : Object;

        function clone() : IUpdater;

    }
}
