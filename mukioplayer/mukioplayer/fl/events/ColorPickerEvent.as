package fl.events
{
    import flash.events.*;

    public class ColorPickerEvent extends Event
    {
        protected var _color:uint;
        public static const ITEM_ROLL_OUT:String = "itemRollOut";
        public static const ITEM_ROLL_OVER:String = "itemRollOver";
        public static const CHANGE:String = "change";
        public static const ENTER:String = "enter";

        public function ColorPickerEvent(param1:String, param2:uint)
        {
            super(param1, true);
            _color = param2;
            return;
        }// end function

        override public function toString() : String
        {
            return formatToString("ColorPickerEvent", "type", "bubbles", "cancelable", "color");
        }// end function

        public function get color() : uint
        {
            return _color;
        }// end function

        override public function clone() : Event
        {
            return new ColorPickerEvent(type, color);
        }// end function

    }
}
