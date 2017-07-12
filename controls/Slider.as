package fl.controls
{
    import fl.core.*;
    import fl.events.*;
    import flash.display.*;
    import flash.events.*;
    import flash.ui.*;

    public class Slider extends UIComponent implements IFocusManagerComponent
    {
        protected var _direction:String;
        protected var _liveDragging:Boolean = false;
        protected var _value:Number = 0;
        protected var _snapInterval:Number = 0;
        protected var _minimum:Number = 0;
        protected var _maximum:Number = 10;
        protected var track:BaseButton;
        protected var _tickInterval:Number = 0;
        protected var tickContainer:Sprite;
        protected var thumb:BaseButton;
        static var defaultStyles:Object = {thumbUpSkin:"SliderThumb_upSkin", thumbOverSkin:"SliderThumb_overSkin", thumbDownSkin:"SliderThumb_downSkin", thumbDisabledSkin:"SliderThumb_disabledSkin", sliderTrackSkin:"SliderTrack_skin", sliderTrackDisabledSkin:"SliderTrack_disabledSkin", tickSkin:"SliderTick_skin", focusRectSkin:null, focusRectPadding:null};
        static const TICK_STYLES:Object = {upSkin:"tickSkin"};
        static const TRACK_STYLES:Object = {upSkin:"sliderTrackSkin", overSkin:"sliderTrackSkin", downSkin:"sliderTrackSkin", disabledSkin:"sliderTrackDisabledSkin"};
        static const THUMB_STYLES:Object = {upSkin:"thumbUpSkin", overSkin:"thumbOverSkin", downSkin:"thumbDownSkin", disabledSkin:"thumbDisabledSkin"};

        public function Slider()
        {
            _direction = SliderDirection.HORIZONTAL;
            _minimum = 0;
            _maximum = 10;
            _value = 0;
            _tickInterval = 0;
            _snapInterval = 0;
            _liveDragging = false;
            setStyles();
            return;
        }// end function

        public function get minimum() : Number
        {
            return _minimum;
        }// end function

        public function set minimum(param1:Number) : void
        {
            _minimum = param1;
            this.value = Math.max(param1, this.value);
            invalidate(InvalidationType.DATA);
            return;
        }// end function

        public function get maximum() : Number
        {
            return _maximum;
        }// end function

        protected function positionThumb() : void
        {
            thumb.x = (_direction == SliderDirection.VERTICAL ? (maximum - minimum - value) : (value - minimum)) / (maximum - minimum) * _width;
            return;
        }// end function

        protected function clearTicks() : void
        {
            if (!tickContainer || !tickContainer.parent)
            {
                return;
            }
            removeChild(tickContainer);
            return;
        }// end function

        protected function onTrackClick(event:MouseEvent) : void
        {
            calculateValue(track.mouseX, InteractionInputType.MOUSE, SliderEventClickTarget.TRACK);
            if (!liveDragging)
            {
                dispatchEvent(new SliderEvent(SliderEvent.CHANGE, value, SliderEventClickTarget.TRACK, InteractionInputType.MOUSE));
            }
            return;
        }// end function

        public function set maximum(param1:Number) : void
        {
            _maximum = param1;
            this.value = Math.min(param1, this.value);
            invalidate(InvalidationType.DATA);
            return;
        }// end function

        public function get liveDragging() : Boolean
        {
            return _liveDragging;
        }// end function

        protected function doDrag(event:MouseEvent) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            _loc_2 = _width / snapInterval;
            _loc_3 = track.mouseX;
            calculateValue(_loc_3, InteractionInputType.MOUSE, SliderEventClickTarget.THUMB);
            dispatchEvent(new SliderEvent(SliderEvent.THUMB_DRAG, value, SliderEventClickTarget.THUMB, InteractionInputType.MOUSE));
            return;
        }// end function

        override protected function keyDownHandler(event:KeyboardEvent) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:Number = NaN;
            var _loc_4:Boolean = false;
            if (!enabled)
            {
                return;
            }
            _loc_2 = snapInterval > 0 ? (snapInterval) : (1);
            _loc_4 = direction == SliderDirection.HORIZONTAL;
            if (event.keyCode == Keyboard.DOWN && !_loc_4 || event.keyCode == Keyboard.LEFT && _loc_4)
            {
                _loc_3 = value - _loc_2;
            }
            else if (event.keyCode == Keyboard.UP && !_loc_4 || event.keyCode == Keyboard.RIGHT && _loc_4)
            {
                _loc_3 = value + _loc_2;
            }
            else if (event.keyCode == Keyboard.PAGE_DOWN && !_loc_4 || event.keyCode == Keyboard.HOME && _loc_4)
            {
                _loc_3 = minimum;
            }
            else if (event.keyCode == Keyboard.PAGE_UP && !_loc_4 || event.keyCode == Keyboard.END && _loc_4)
            {
                _loc_3 = maximum;
            }
            if (!isNaN(_loc_3))
            {
                event.stopPropagation();
                doSetValue(_loc_3, InteractionInputType.KEYBOARD, null, event.keyCode);
            }
            return;
        }// end function

        override public function set enabled(param1:Boolean) : void
        {
            if (enabled == param1)
            {
                return;
            }
            super.enabled = param1;
            var _loc_2:* = param1;
            thumb.enabled = param1;
            track.enabled = _loc_2;
            return;
        }// end function

        protected function thumbPressHandler(event:MouseEvent) : void
        {
            stage.addEventListener(MouseEvent.MOUSE_MOVE, doDrag, false, 0, true);
            stage.addEventListener(MouseEvent.MOUSE_UP, thumbReleaseHandler, false, 0, true);
            dispatchEvent(new SliderEvent(SliderEvent.THUMB_PRESS, value, InteractionInputType.MOUSE, SliderEventClickTarget.THUMB));
            return;
        }// end function

        public function get snapInterval() : Number
        {
            return _snapInterval;
        }// end function

        protected function thumbReleaseHandler(event:MouseEvent) : void
        {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, doDrag);
            stage.removeEventListener(MouseEvent.MOUSE_UP, thumbReleaseHandler);
            dispatchEvent(new SliderEvent(SliderEvent.THUMB_RELEASE, value, InteractionInputType.MOUSE, SliderEventClickTarget.THUMB));
            dispatchEvent(new SliderEvent(SliderEvent.CHANGE, value, SliderEventClickTarget.THUMB, InteractionInputType.MOUSE));
            return;
        }// end function

        public function set liveDragging(param1:Boolean) : void
        {
            _liveDragging = param1;
            return;
        }// end function

        public function set value(param1:Number) : void
        {
            doSetValue(param1);
            return;
        }// end function

        public function set direction(param1:String) : void
        {
            var _loc_2:Boolean = false;
            _direction = param1;
            _loc_2 = _direction == SliderDirection.VERTICAL;
            if (isLivePreview)
            {
                if (_loc_2)
                {
                    setScaleY(-1);
                    y = track.height;
                }
                else
                {
                    setScaleY(1);
                    y = 0;
                }
                positionThumb();
                return;
            }
            if (_loc_2 && componentInspectorSetting)
            {
                if (rotation % 90 == 0)
                {
                    setScaleY(-1);
                }
            }
            if (!componentInspectorSetting)
            {
                rotation = _loc_2 ? (90) : (0);
            }
            return;
        }// end function

        public function set tickInterval(param1:Number) : void
        {
            _tickInterval = param1;
            invalidate(InvalidationType.SIZE);
            return;
        }// end function

        override public function get enabled() : Boolean
        {
            return super.enabled;
        }// end function

        override protected function draw() : void
        {
            if (isInvalid(InvalidationType.STYLES))
            {
                setStyles();
                invalidate(InvalidationType.SIZE, false);
            }
            if (isInvalid(InvalidationType.SIZE))
            {
                track.setSize(_width, track.height);
                track.drawNow();
                thumb.drawNow();
            }
            if (tickInterval > 0)
            {
                drawTicks();
            }
            else
            {
                clearTicks();
            }
            positionThumb();
            super.draw();
            return;
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            thumb = new BaseButton();
            thumb.setSize(13, 13);
            thumb.autoRepeat = false;
            addChild(thumb);
            thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbPressHandler, false, 0, true);
            track = new BaseButton();
            track.move(0, 0);
            track.setSize(80, 4);
            track.autoRepeat = false;
            track.useHandCursor = false;
            track.addEventListener(MouseEvent.CLICK, onTrackClick, false, 0, true);
            addChildAt(track, 0);
            return;
        }// end function

        public function set snapInterval(param1:Number) : void
        {
            _snapInterval = param1;
            return;
        }// end function

        public function get value() : Number
        {
            return _value;
        }// end function

        public function get direction() : String
        {
            return _direction;
        }// end function

        public function get tickInterval() : Number
        {
            return _tickInterval;
        }// end function

        override public function setSize(param1:Number, param2:Number) : void
        {
            if (_direction == SliderDirection.VERTICAL && !isLivePreview)
            {
                super.setSize(param2, param1);
            }
            else
            {
                super.setSize(param1, param2);
            }
            invalidate(InvalidationType.SIZE);
            return;
        }// end function

        protected function drawTicks() : void
        {
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:uint = 0;
            var _loc_5:DisplayObject = null;
            clearTicks();
            tickContainer = new Sprite();
            _loc_1 = maximum < 1 ? (tickInterval / 100) : (tickInterval);
            _loc_2 = (maximum - minimum) / _loc_1;
            _loc_3 = _width / _loc_2;
            _loc_4 = 0;
            while (_loc_4 <= _loc_2)
            {
                
                _loc_5 = getDisplayObjectInstance(getStyleValue("tickSkin"));
                _loc_5.x = _loc_3 * _loc_4;
                _loc_5.y = track.y - _loc_5.height - 2;
                tickContainer.addChild(_loc_5);
                _loc_4 = _loc_4 + 1;
            }
            addChild(tickContainer);
            return;
        }// end function

        protected function calculateValue(param1:Number, param2:String, param3:String, param4:int = ) : void
        {
            var _loc_5:Number = NaN;
            _loc_5 = param1 / _width * (maximum - minimum);
            if (_direction == SliderDirection.VERTICAL)
            {
                _loc_5 = maximum - _loc_5;
            }
            else
            {
                _loc_5 = minimum + _loc_5;
            }
            doSetValue(_loc_5, param2, param3, param4);
            return;
        }// end function

        protected function getPrecision(param1:Number) : Number
        {
            var _loc_2:String = null;
            _loc_2 = param1.toString();
            if (_loc_2.indexOf(".") == -1)
            {
                return 0;
            }
            return _loc_2.split(".").pop().length;
        }// end function

        protected function doSetValue(param1:Number, param2:String = null, param3:String = null, param4:int = ) : void
        {
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            _loc_5 = _value;
            if (_snapInterval != 0 && _snapInterval != 1)
            {
                _loc_6 = Math.pow(10, getPrecision(snapInterval));
                _loc_7 = _snapInterval * _loc_6;
                _loc_8 = Math.round(param1 * _loc_6);
                _loc_9 = Math.round(_loc_8 / _loc_7) * _loc_7;
                param1 = _loc_9 / _loc_6;
                _value = Math.max(minimum, Math.min(maximum, param1));
            }
            else
            {
                _value = Math.max(minimum, Math.min(maximum, Math.round(param1)));
            }
            if (_loc_5 != _value && (liveDragging && param3 != null || param2 == InteractionInputType.KEYBOARD))
            {
                dispatchEvent(new SliderEvent(SliderEvent.CHANGE, value, param3, param2, param4));
            }
            positionThumb();
            return;
        }// end function

        protected function setStyles() : void
        {
            copyStylesToChild(thumb, THUMB_STYLES);
            copyStylesToChild(track, TRACK_STYLES);
            return;
        }// end function

        public static function getStyleDefinition() : Object
        {
            return defaultStyles;
        }// end function

    }
}
