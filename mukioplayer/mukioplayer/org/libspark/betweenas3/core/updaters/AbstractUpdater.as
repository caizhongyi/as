package org.libspark.betweenas3.core.updaters
{

    public class AbstractUpdater extends Object implements IUpdater
    {
        protected var _isResolved:Boolean = false;

        public function AbstractUpdater()
        {
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

        public function set target(param1:Object) : void
        {
            return;
        }// end function

        public function update(param1:Number) : void
        {
            if (!this._isResolved)
            {
                this.resolveValues();
                this._isResolved = true;
            }
            this.updateObject(param1);
            return;
        }// end function

        protected function newInstance() : AbstractUpdater
        {
            return null;
        }// end function

        protected function resolveValues() : void
        {
            return;
        }// end function

        protected function updateObject(param1:Number) : void
        {
            return;
        }// end function

        public function setSourceValue(param1:String, param2:Number, param3:Boolean = false) : void
        {
            return;
        }// end function

        public function get target() : Object
        {
            return null;
        }// end function

        public function getObject(param1:String) : Object
        {
            return null;
        }// end function

        public function clone() : IUpdater
        {
            var _loc_1:* = this.newInstance();
            if (_loc_1 != null)
            {
                _loc_1.copyFrom(this);
            }
            return _loc_1;
        }// end function

        protected function copyFrom(param1:AbstractUpdater) : void
        {
            return;
        }// end function

    }
}
