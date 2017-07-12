package org.libspark.betweenas3.core.updaters
{
    import org.libspark.betweenas3.core.easing.*;

    public class PhysicalUpdaterLadder extends Object implements IPhysicalUpdater
    {
        private var _parent:IPhysicalUpdater;
        private var _propertyName:String;
        private var _child:IPhysicalUpdater;
        private var _duration:Number = 0;

        public function PhysicalUpdaterLadder(param1:IPhysicalUpdater, param2:IPhysicalUpdater, param3:String)
        {
            this._parent = param1;
            this._child = param2;
            this._propertyName = param3;
            this._duration = param2.duration;
            return;
        }// end function

        public function setDestinationValue(param1:String, param2:Number, param3:Boolean = false) : void
        {
            return;
        }// end function

        public function setObject(param1:String, param2:Object) : void
        {
            return;
        }// end function

        public function get target() : Object
        {
            return null;
        }// end function

        public function setSourceValue(param1:String, param2:Number, param3:Boolean = false) : void
        {
            return;
        }// end function

        public function get child() : IPhysicalUpdater
        {
            return this._child;
        }// end function

        public function set easing(param1:IPhysicalEasing) : void
        {
            return;
        }// end function

        public function update(param1:Number) : void
        {
            this._child.update(param1);
            this._parent.setObject(this._propertyName, this._child.target);
            return;
        }// end function

        public function set target(param1:Object) : void
        {
            return;
        }// end function

        public function get duration() : Number
        {
            return this._duration;
        }// end function

        public function get parent() : IPhysicalUpdater
        {
            return this._parent;
        }// end function

        public function resolveValues() : void
        {
            return;
        }// end function

        public function get easing() : IPhysicalEasing
        {
            return null;
        }// end function

        public function getObject(param1:String) : Object
        {
            return null;
        }// end function

        public function clone() : IUpdater
        {
            return new PhysicalUpdaterLadder(this._parent, this._child, this._propertyName);
        }// end function

    }
}
