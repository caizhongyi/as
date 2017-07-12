package org.libspark.betweenas3.core.updaters
{

    public class UpdaterLadder extends Object implements IUpdater
    {
        private var _parent:IUpdater;
        private var _propertyName:String;
        private var _child:IUpdater;

        public function UpdaterLadder(param1:IUpdater, param2:IUpdater, param3:String)
        {
            this._parent = param1;
            this._child = param2;
            this._propertyName = param3;
            return;
        }// end function

        public function setObject(param1:String, param2:Object) : void
        {
            return;
        }// end function

        public function setDestinationValue(param1:String, param2:Number, param3:Boolean = false) : void
        {
            return;
        }// end function

        public function setSourceValue(param1:String, param2:Number, param3:Boolean = false) : void
        {
            return;
        }// end function

        public function update(param1:Number) : void
        {
            this._child.update(param1);
            this._parent.setObject(this._propertyName, this._child.target);
            return;
        }// end function

        public function get child() : IUpdater
        {
            return this._child;
        }// end function

        public function clone() : IUpdater
        {
            return new UpdaterLadder(this._parent, this._child, this._propertyName);
        }// end function

        public function get target() : Object
        {
            return null;
        }// end function

        public function set target(param1:Object) : void
        {
            return;
        }// end function

        public function get parent() : IUpdater
        {
            return this._parent;
        }// end function

        public function resolveValues() : void
        {
            return;
        }// end function

        public function getObject(param1:String) : Object
        {
            return null;
        }// end function

    }
}
