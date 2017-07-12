package org.libspark.betweenas3.core.tweens.actions
{
    import flash.display.*;
    import org.libspark.betweenas3.core.ticker.*;
    import org.libspark.betweenas3.core.tweens.*;

    public class AddChildAction extends AbstractActionTween
    {
        private var _target:DisplayObject;
        private var _parent:DisplayObjectContainer;

        public function AddChildAction(param1:ITicker, param2:DisplayObject, param3:DisplayObjectContainer)
        {
            super(param1);
            this._target = param2;
            this._parent = param3;
            return;
        }// end function

        public function get target() : DisplayObject
        {
            return this._target;
        }// end function

        override protected function rollback() : void
        {
            if (this._target != null && this._parent != null && this._target.parent == this._parent)
            {
                this._parent.removeChild(this._target);
            }
            return;
        }// end function

        override protected function action() : void
        {
            if (this._target != null && this._parent != null && this._target.parent != this._parent)
            {
                this._parent.addChild(this._target);
            }
            return;
        }// end function

        public function get parent() : DisplayObjectContainer
        {
            return this._parent;
        }// end function

    }
}
