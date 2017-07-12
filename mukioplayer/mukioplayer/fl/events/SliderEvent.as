package fl.events
{
    import flash.events.*;

    public class SliderEvent extends Event
    {
        protected var _triggerEvent:String;
        protected var _keyCode:Number;
        protected var _value:Number;
        protected var _clickTarget:String;
        public static const CHANGE:String = "change";
        public static const THUMB_PRESS:String = "thumbPress";
        public static const THUMB_DRAG:String = "thumbDrag";
        public static const THUMB_RELEASE:String = "thumbRelease";

        public function SliderEvent(param1:String, param2:Number, param3:String, param4:String, param5:int = 0)
        {
            _value = param2;
            _keyCode = param5;
            _triggerEvent = param4;
            _clickTarget = param3;
            super(param1);
            return;
        }// end function

        public function get clickTarget() : String
        {
            return _clickTarget;
        }// end function

        override public function clone() : Event
        {
            return new SliderEvent(type, _value, _clickTarget, _triggerEvent, _keyCode);
        }// end function

        override public function toString() : String
        {
            return formatToString("SliderEvent", "type", "value", "bubbles", "cancelable", "keyCode", "triggerEvent", "clickTarget");
        }// end function

        public function get triggerEvent() : String
        {
            return _triggerEvent;
        }// end function

        public function get value() : Number
        {
            return _value;
        }// end function

        public function get keyCode() : Number
        {
            return _keyCode;
        }// end function

    }
}
