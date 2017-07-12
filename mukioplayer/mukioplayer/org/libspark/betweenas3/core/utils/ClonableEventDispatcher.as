package org.libspark.betweenas3.core.utils
{
    import __AS3__.vec.*;
    import flash.events.*;
    import flash.utils.*;

    public class ClonableEventDispatcher extends EventDispatcher
    {
        private var _listeners:Dictionary;

        public function ClonableEventDispatcher(param1:IEventDispatcher = null)
        {
            this._listeners = new Dictionary();
            super(param1);
            return;
        }// end function

        override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
        {
            super.addEventListener(param1, param2, param3, param4, param5);
            var _loc_6:* = new ListenerData();
            new ListenerData().listener = param2;
            _loc_6.useCapture = param3;
            _loc_6.priority = param4;
            _loc_6.useWeakReference = param5;
            var _loc_7:* = new Vector.<ListenerData>;
            this._listeners[param1] = new Vector.<ListenerData>;
            ((this._listeners[param1] || _loc_7) as Vector.<ListenerData>).push(_loc_6);
            return;
        }// end function

        override public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
        {
            var _loc_5:uint = 0;
            var _loc_6:int = 0;
            var _loc_7:ListenerData = null;
            super.removeEventListener(param1, param2, param3);
            var _loc_4:* = this._listeners[param1] as Vector.<ListenerData>;
            if (this._listeners[param1] as Vector.<ListenerData> != null)
            {
                _loc_5 = _loc_4.length;
                _loc_6 = 0;
                while (_loc_6 < _loc_5)
                {
                    
                    _loc_7 = _loc_4[_loc_6] as ListenerData;
                    if (_loc_7.listener == param2 && _loc_7.useCapture == param3)
                    {
                        _loc_4.splice(_loc_6, 1);
                        _loc_6 = _loc_6 - 1;
                        _loc_5 = _loc_5 - 1;
                    }
                    _loc_6++;
                }
            }
            return;
        }// end function

        public function copyFrom(param1:ClonableEventDispatcher) : void
        {
            var _loc_3:String = null;
            var _loc_4:Vector.<ListenerData> = null;
            var _loc_5:uint = 0;
            var _loc_6:uint = 0;
            var _loc_7:ListenerData = null;
            var _loc_2:* = param1._listeners;
            for (_loc_3 in _loc_2)
            {
                
                _loc_4 = _loc_2[_loc_3] as Vector.<ListenerData>;
                _loc_5 = _loc_4.length;
                _loc_6 = 0;
                while (_loc_6 < _loc_5)
                {
                    
                    _loc_7 = _loc_4[_loc_6] as ListenerData;
                    this.addEventListener(_loc_3, _loc_7.listener, _loc_7.useCapture, _loc_7.priority, _loc_7.useWeakReference);
                    _loc_6 = _loc_6 + 1;
                }
            }
            return;
        }// end function

    }
}

class ListenerData extends Object
{
    public var priority:int;
    public var useCapture:Boolean;
    public var listener:Function;
    public var useWeakReference:Boolean;

    function ListenerData()
    {
        return;
    }// end function

}

