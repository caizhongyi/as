package fl.controls
{
    import fl.core.*;
    import fl.events.*;
    import fl.managers.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.ui.*;

    public class ColorPicker extends UIComponent implements IFocusManagerComponent
    {
        protected var paletteBG:DisplayObject;
        protected var customColors:Array;
        protected var palette:Sprite;
        protected var isOpen:Boolean = false;
        protected var swatchButton:BaseButton;
        protected var selectedSwatch:Sprite;
        protected var textFieldBG:DisplayObject;
        protected var colorWell:DisplayObject;
        protected var rollOverColor:int = -1;
        protected var colorHash:Object;
        protected var swatchSelectedSkin:DisplayObject;
        protected var _showTextField:Boolean = true;
        protected var currRowIndex:int;
        protected var doOpen:Boolean = false;
        protected var currColIndex:int;
        protected var swatchMap:Array;
        protected var _selectedColor:uint;
        protected var _editable:Boolean = true;
        public var textField:TextField;
        protected var swatches:Sprite;
        public static var defaultColors:Array;
        private static var defaultStyles:Object = {upSkin:"ColorPicker_upSkin", disabledSkin:"ColorPicker_disabledSkin", overSkin:"ColorPicker_overSkin", downSkin:"ColorPicker_downSkin", colorWell:"ColorPicker_colorWell", swatchSkin:"ColorPicker_swatchSkin", swatchSelectedSkin:"ColorPicker_swatchSelectedSkin", swatchWidth:10, swatchHeight:10, columnCount:18, swatchPadding:1, textFieldSkin:"ColorPicker_textFieldSkin", textFieldWidth:null, textFieldHeight:null, textPadding:3, background:"ColorPicker_backgroundSkin", backgroundPadding:5, textFormat:null, focusRectSkin:null, focusRectPadding:null, embedFonts:false};
        static const SWATCH_STYLES:Object = {disabledSkin:"swatchSkin", downSkin:"swatchSkin", overSkin:"swatchSkin", upSkin:"swatchSkin"};
        static const POPUP_BUTTON_STYLES:Object = {disabledSkin:"disabledSkin", downSkin:"downSkin", overSkin:"overSkin", upSkin:"upSkin"};

        public function ColorPicker()
        {
            rollOverColor = -1;
            _editable = true;
            _showTextField = true;
            isOpen = false;
            doOpen = false;
            return;
        }// end function

        public function set imeMode(param1:String) : void
        {
            _imeMode = param1;
            return;
        }// end function

        protected function drawSwatchHighlight() : void
        {
            var _loc_1:Object = null;
            var _loc_2:Number = NaN;
            cleanUpSelected();
            _loc_1 = getStyleValue("swatchSelectedSkin");
            _loc_2 = getStyleValue("swatchPadding") as Number;
            if (_loc_1 != null)
            {
                swatchSelectedSkin = getDisplayObjectInstance(_loc_1);
                swatchSelectedSkin.x = 0;
                swatchSelectedSkin.y = 0;
                swatchSelectedSkin.width = (getStyleValue("swatchWidth") as Number) + 2;
                swatchSelectedSkin.height = (getStyleValue("swatchHeight") as Number) + 2;
            }
            return;
        }// end function

        protected function setColorWellColor(param1:ColorTransform) : void
        {
            if (!colorWell)
            {
                return;
            }
            colorWell.transform.colorTransform = param1;
            return;
        }// end function

        override protected function isOurFocus(param1:DisplayObject) : Boolean
        {
            return param1 == textField || super.isOurFocus(param1);
        }// end function

        public function open() : void
        {
            var _loc_1:IFocusManager = null;
            if (!_enabled)
            {
                return;
            }
            doOpen = true;
            _loc_1 = focusManager;
            if (_loc_1)
            {
                _loc_1.defaultButtonEnabled = false;
            }
            invalidate(InvalidationType.STATE);
            return;
        }// end function

        protected function setTextEditable() : void
        {
            if (!showTextField)
            {
                return;
            }
            textField.type = editable ? (TextFieldType.INPUT) : (TextFieldType.DYNAMIC);
            textField.selectable = editable;
            return;
        }// end function

        protected function createSwatch(param1:uint) : Sprite
        {
            var _loc_2:Sprite = null;
            var _loc_3:BaseButton = null;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Graphics = null;
            _loc_2 = new Sprite();
            _loc_3 = new BaseButton();
            _loc_3.focusEnabled = false;
            _loc_4 = getStyleValue("swatchWidth") as Number;
            _loc_5 = getStyleValue("swatchHeight") as Number;
            _loc_3.setSize(_loc_4, _loc_5);
            _loc_3.transform.colorTransform = new ColorTransform(0, 0, 0, 1, param1 >> 16, param1 >> 8 & 255, param1 & 255, 0);
            copyStylesToChild(_loc_3, SWATCH_STYLES);
            _loc_3.mouseEnabled = false;
            _loc_3.drawNow();
            _loc_3.name = "color";
            _loc_2.addChild(_loc_3);
            _loc_6 = getStyleValue("swatchPadding") as Number;
            _loc_7 = _loc_2.graphics;
            _loc_7.beginFill(0);
            _loc_7.drawRect(-_loc_6, -_loc_6, _loc_4 + _loc_6 * 2, _loc_5 + _loc_6 * 2);
            _loc_7.endFill();
            _loc_2.addEventListener(MouseEvent.CLICK, onSwatchClick, false, 0, true);
            _loc_2.addEventListener(MouseEvent.MOUSE_OVER, onSwatchOver, false, 0, true);
            _loc_2.addEventListener(MouseEvent.MOUSE_OUT, onSwatchOut, false, 0, true);
            return _loc_2;
        }// end function

        protected function onSwatchOut(event:MouseEvent) : void
        {
            var _loc_2:ColorTransform = null;
            _loc_2 = event.target.transform.colorTransform;
            dispatchEvent(new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OUT, _loc_2.color));
            return;
        }// end function

        override protected function keyDownHandler(event:KeyboardEvent) : void
        {
            var _loc_2:ColorTransform = null;
            var _loc_3:Sprite = null;
            switch(event.keyCode)
            {
                case Keyboard.SHIFT:
                case Keyboard.CONTROL:
                {
                    return;
                }
                default:
                {
                    break;
                }
            }
            if (event.ctrlKey)
            {
                switch(event.keyCode)
                {
                    case Keyboard.DOWN:
                    {
                        open();
                        break;
                    }
                    case Keyboard.UP:
                    {
                        close();
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                return;
            }
            if (!isOpen)
            {
                switch(event.keyCode)
                {
                    case Keyboard.UP:
                    case Keyboard.DOWN:
                    case Keyboard.LEFT:
                    case Keyboard.RIGHT:
                    case Keyboard.SPACE:
                    {
                        open();
                        return;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            textField.maxChars = event.keyCode == "#".charCodeAt(0) || textField.text.indexOf("#") > -1 ? (7) : (6);
            switch(event.keyCode)
            {
                case Keyboard.TAB:
                {
                    _loc_3 = findSwatch(_selectedColor);
                    setSwatchHighlight(_loc_3);
                    return;
                }
                case Keyboard.HOME:
                {
                    var _loc_4:int = 0;
                    currRowIndex = 0;
                    currColIndex = _loc_4;
                    break;
                }
                case Keyboard.END:
                {
                    currColIndex = swatchMap[(swatchMap.length - 1)].length - 1;
                    currRowIndex = swatchMap.length - 1;
                    break;
                }
                case Keyboard.PAGE_DOWN:
                {
                    currRowIndex = swatchMap.length - 1;
                    break;
                }
                case Keyboard.PAGE_UP:
                {
                    currRowIndex = 0;
                    break;
                }
                case Keyboard.ESCAPE:
                {
                    if (isOpen)
                    {
                        selectedColor = _selectedColor;
                    }
                    close();
                    return;
                }
                case Keyboard.ENTER:
                {
                    return;
                }
                case Keyboard.UP:
                {
                    currRowIndex = Math.max(-1, (currRowIndex - 1));
                    if (currRowIndex == -1)
                    {
                        currRowIndex = swatchMap.length - 1;
                    }
                    break;
                }
                case Keyboard.DOWN:
                {
                    currRowIndex = Math.min(swatchMap.length, (currRowIndex + 1));
                    if (currRowIndex == swatchMap.length)
                    {
                        currRowIndex = 0;
                    }
                    break;
                }
                case Keyboard.RIGHT:
                {
                    currColIndex = Math.min(swatchMap[currRowIndex].length, (currColIndex + 1));
                    if (currColIndex == swatchMap[currRowIndex].length)
                    {
                        currColIndex = 0;
                        currRowIndex = Math.min(swatchMap.length, (currRowIndex + 1));
                        if (currRowIndex == swatchMap.length)
                        {
                            currRowIndex = 0;
                        }
                    }
                    break;
                }
                case Keyboard.LEFT:
                {
                    currColIndex = Math.max(-1, (currColIndex - 1));
                    if (currColIndex == -1)
                    {
                        currColIndex = swatchMap[currRowIndex].length - 1;
                        currRowIndex = Math.max(-1, (currRowIndex - 1));
                        if (currRowIndex == -1)
                        {
                            currRowIndex = swatchMap.length - 1;
                        }
                    }
                    break;
                }
                default:
                {
                    return;
                    break;
                }
            }
            _loc_2 = swatchMap[currRowIndex][currColIndex].getChildByName("color").transform.colorTransform;
            rollOverColor = _loc_2.color;
            setColorWellColor(_loc_2);
            setSwatchHighlight(swatchMap[currRowIndex][currColIndex]);
            setColorText(_loc_2.color);
            return;
        }// end function

        public function get editable() : Boolean
        {
            return _editable;
        }// end function

        override protected function focusInHandler(event:FocusEvent) : void
        {
            super.focusInHandler(event);
            setIMEMode(true);
            return;
        }// end function

        protected function onStageClick(event:MouseEvent) : void
        {
            if (!contains(event.target as DisplayObject) && !palette.contains(event.target as DisplayObject))
            {
                selectedColor = _selectedColor;
                close();
            }
            return;
        }// end function

        protected function onSwatchOver(event:MouseEvent) : void
        {
            var _loc_2:BaseButton = null;
            var _loc_3:ColorTransform = null;
            _loc_2 = event.target.getChildByName("color") as BaseButton;
            _loc_3 = _loc_2.transform.colorTransform;
            setColorWellColor(_loc_3);
            setSwatchHighlight(event.target as Sprite);
            setColorText(_loc_3.color);
            dispatchEvent(new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OVER, _loc_3.color));
            return;
        }// end function

        override public function set enabled(param1:Boolean) : void
        {
            super.enabled = param1;
            if (!param1)
            {
                close();
            }
            swatchButton.enabled = param1;
            return;
        }// end function

        override protected function keyUpHandler(event:KeyboardEvent) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:ColorTransform = null;
            var _loc_4:String = null;
            var _loc_5:Sprite = null;
            if (!isOpen)
            {
                return;
            }
            _loc_3 = new ColorTransform();
            if (editable && showTextField)
            {
                _loc_4 = textField.text;
                if (_loc_4.indexOf("#") > -1)
                {
                    _loc_4 = _loc_4.replace(/^\s+|\s+$/g, "");
                    _loc_4 = _loc_4.replace(/#/g, "");
                }
                _loc_2 = parseInt(_loc_4, 16);
                _loc_5 = findSwatch(_loc_2);
                setSwatchHighlight(_loc_5);
                _loc_3.color = _loc_2;
                setColorWellColor(_loc_3);
            }
            else
            {
                _loc_2 = rollOverColor;
                _loc_3.color = _loc_2;
            }
            if (event.keyCode != Keyboard.ENTER)
            {
                return;
            }
            dispatchEvent(new ColorPickerEvent(ColorPickerEvent.ENTER, _loc_2));
            _selectedColor = rollOverColor;
            setColorText(_loc_3.color);
            rollOverColor = _loc_3.color;
            dispatchEvent(new ColorPickerEvent(ColorPickerEvent.CHANGE, selectedColor));
            close();
            return;
        }// end function

        protected function drawBG() : void
        {
            var _loc_1:Object = null;
            var _loc_2:Number = NaN;
            _loc_1 = getStyleValue("background");
            if (_loc_1 != null)
            {
                paletteBG = getDisplayObjectInstance(_loc_1) as Sprite;
            }
            if (paletteBG == null)
            {
                return;
            }
            _loc_2 = Number(getStyleValue("backgroundPadding"));
            paletteBG.width = Math.max(showTextField ? (textFieldBG.width) : (0), swatches.width) + _loc_2 * 2;
            paletteBG.height = swatches.y + swatches.height + _loc_2;
            palette.addChildAt(paletteBG, 0);
            return;
        }// end function

        protected function positionTextField() : void
        {
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            if (!showTextField)
            {
                return;
            }
            _loc_1 = getStyleValue("backgroundPadding") as Number;
            _loc_2 = getStyleValue("textPadding") as Number;
            textFieldBG.x = paletteBG.x + _loc_1;
            textFieldBG.y = paletteBG.y + _loc_1;
            textField.x = textFieldBG.x + _loc_2;
            textField.y = textFieldBG.y + _loc_2;
            return;
        }// end function

        protected function setEmbedFonts() : void
        {
            var _loc_1:Object = null;
            _loc_1 = getStyleValue("embedFonts");
            if (_loc_1 != null)
            {
                textField.embedFonts = _loc_1;
            }
            return;
        }// end function

        public function set showTextField(param1:Boolean) : void
        {
            invalidate(InvalidationType.STYLES);
            _showTextField = param1;
            return;
        }// end function

        protected function addStageListener(event:Event = null) : void
        {
            stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageClick, false, 0, true);
            return;
        }// end function

        protected function drawPalette() : void
        {
            if (isOpen)
            {
                stage.removeChild(palette);
            }
            palette = new Sprite();
            drawTextField();
            drawSwatches();
            drawBG();
            return;
        }// end function

        protected function showPalette() : void
        {
            var _loc_1:Sprite = null;
            if (isOpen)
            {
                positionPalette();
                return;
            }
            addEventListener(Event.ENTER_FRAME, addCloseListener, false, 0, true);
            stage.addChild(palette);
            isOpen = true;
            positionPalette();
            dispatchEvent(new Event(Event.OPEN));
            stage.focus = textField;
            _loc_1 = selectedSwatch;
            if (_loc_1 == null)
            {
                _loc_1 = findSwatch(_selectedColor);
            }
            setSwatchHighlight(_loc_1);
            return;
        }// end function

        public function set editable(param1:Boolean) : void
        {
            _editable = param1;
            invalidate(InvalidationType.STATE);
            return;
        }// end function

        public function set colors(param1:Array) : void
        {
            customColors = param1;
            invalidate(InvalidationType.DATA);
            return;
        }// end function

        protected function drawTextField() : void
        {
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_3:Object = null;
            var _loc_4:TextFormat = null;
            var _loc_5:TextFormat = null;
            if (!showTextField)
            {
                return;
            }
            _loc_1 = getStyleValue("backgroundPadding") as Number;
            _loc_2 = getStyleValue("textPadding") as Number;
            textFieldBG = getDisplayObjectInstance(getStyleValue("textFieldSkin"));
            if (textFieldBG != null)
            {
                palette.addChild(textFieldBG);
                var _loc_6:* = _loc_1;
                textFieldBG.y = _loc_1;
                textFieldBG.x = _loc_6;
            }
            _loc_3 = UIComponent.getStyleDefinition();
            _loc_4 = enabled ? (_loc_3.defaultTextFormat as TextFormat) : (_loc_3.defaultDisabledTextFormat as TextFormat);
            textField.setTextFormat(_loc_4);
            _loc_5 = getStyleValue("textFormat") as TextFormat;
            if (_loc_5 != null)
            {
                textField.setTextFormat(_loc_5);
            }
            else
            {
                _loc_5 = _loc_4;
            }
            textField.defaultTextFormat = _loc_5;
            setEmbedFonts();
            textField.restrict = "A-Fa-f0-9#";
            textField.maxChars = 6;
            palette.addChild(textField);
            textField.text = " #888888 ";
            textField.height = textField.textHeight + 3;
            textField.width = textField.textWidth + 3;
            textField.text = "";
            var _loc_6:* = _loc_1 + _loc_2;
            textField.y = _loc_1 + _loc_2;
            textField.x = _loc_6;
            textFieldBG.width = textField.width + _loc_2 * 2;
            textFieldBG.height = textField.height + _loc_2 * 2;
            setTextEditable();
            return;
        }// end function

        protected function setColorText(param1:uint) : void
        {
            if (textField == null)
            {
                return;
            }
            textField.text = "#" + colorToString(param1);
            return;
        }// end function

        protected function colorToString(param1:uint) : String
        {
            var _loc_2:String = null;
            _loc_2 = param1.toString(16);
            while (_loc_2.length < 6)
            {
                
                _loc_2 = "0" + _loc_2;
            }
            return _loc_2;
        }// end function

        public function get imeMode() : String
        {
            return _imeMode;
        }// end function

        public function set selectedColor(param1:uint) : void
        {
            var _loc_2:ColorTransform = null;
            if (!_enabled)
            {
                return;
            }
            _selectedColor = param1;
            rollOverColor = -1;
            var _loc_3:int = 0;
            currRowIndex = 0;
            currColIndex = _loc_3;
            _loc_2 = new ColorTransform();
            _loc_2.color = param1;
            setColorWellColor(_loc_2);
            invalidate(InvalidationType.DATA);
            return;
        }// end function

        override protected function focusOutHandler(event:FocusEvent) : void
        {
            if (event.relatedObject == textField)
            {
                setFocus();
                return;
            }
            if (isOpen)
            {
                close();
            }
            super.focusOutHandler(event);
            setIMEMode(false);
            return;
        }// end function

        protected function onPopupButtonClick(event:MouseEvent) : void
        {
            if (isOpen)
            {
                close();
            }
            else
            {
                open();
            }
            return;
        }// end function

        protected function positionPalette() : void
        {
            var _loc_1:Point = null;
            var _loc_2:Number = NaN;
            _loc_1 = swatchButton.localToGlobal(new Point(0, 0));
            _loc_2 = getStyleValue("backgroundPadding") as Number;
            if (_loc_1.x + palette.width > stage.stageWidth)
            {
                palette.x = _loc_1.x - palette.width << 0;
            }
            else
            {
                palette.x = _loc_1.x + swatchButton.width + _loc_2 << 0;
            }
            palette.y = Math.max(0, Math.min(_loc_1.y, stage.stageHeight - palette.height)) << 0;
            return;
        }// end function

        public function get hexValue() : String
        {
            if (colorWell == null)
            {
                return colorToString(0);
            }
            return colorToString(colorWell.transform.colorTransform.color);
        }// end function

        override public function get enabled() : Boolean
        {
            return super.enabled;
        }// end function

        protected function setSwatchHighlight(param1:Sprite) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:* = undefined;
            if (param1 == null)
            {
                if (palette.contains(swatchSelectedSkin))
                {
                    palette.removeChild(swatchSelectedSkin);
                }
                return;
            }
            else if (!palette.contains(swatchSelectedSkin) && colors.length > 0)
            {
                palette.addChild(swatchSelectedSkin);
            }
            else if (!colors.length)
            {
                return;
            }
            _loc_2 = getStyleValue("swatchPadding") as Number;
            palette.setChildIndex(swatchSelectedSkin, (palette.numChildren - 1));
            swatchSelectedSkin.x = swatches.x + param1.x - 1;
            swatchSelectedSkin.y = swatches.y + param1.y - 1;
            _loc_3 = param1.getChildByName("color").transform.colorTransform.color;
            currColIndex = colorHash[_loc_3].col;
            currRowIndex = colorHash[_loc_3].row;
            return;
        }// end function

        protected function onSwatchClick(event:MouseEvent) : void
        {
            var _loc_2:ColorTransform = null;
            _loc_2 = event.target.getChildByName("color").transform.colorTransform;
            _selectedColor = _loc_2.color;
            dispatchEvent(new ColorPickerEvent(ColorPickerEvent.CHANGE, selectedColor));
            close();
            return;
        }// end function

        override protected function draw() : void
        {
            if (isInvalid(InvalidationType.STYLES, InvalidationType.DATA))
            {
                setStyles();
                drawPalette();
                setEmbedFonts();
                invalidate(InvalidationType.DATA, false);
                invalidate(InvalidationType.STYLES, false);
            }
            if (isInvalid(InvalidationType.DATA))
            {
                drawSwatchHighlight();
                setColorDisplay();
            }
            if (isInvalid(InvalidationType.STATE))
            {
                setTextEditable();
                if (doOpen)
                {
                    doOpen = false;
                    showPalette();
                }
                colorWell.visible = enabled;
            }
            if (isInvalid(InvalidationType.SIZE, InvalidationType.STYLES))
            {
                swatchButton.setSize(width, height);
                swatchButton.drawNow();
                colorWell.width = width;
                colorWell.height = height;
            }
            super.draw();
            return;
        }// end function

        protected function drawSwatches() : void
        {
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:uint = 0;
            var _loc_8:int = 0;
            var _loc_9:uint = 0;
            var _loc_10:Sprite = null;
            _loc_1 = getStyleValue("backgroundPadding") as Number;
            _loc_2 = showTextField ? (textFieldBG.y + textFieldBG.height + _loc_1) : (_loc_1);
            swatches = new Sprite();
            palette.addChild(swatches);
            swatches.x = _loc_1;
            swatches.y = _loc_2;
            _loc_3 = getStyleValue("columnCount") as uint;
            _loc_4 = getStyleValue("swatchPadding") as uint;
            _loc_5 = getStyleValue("swatchWidth") as Number;
            _loc_6 = getStyleValue("swatchHeight") as Number;
            colorHash = {};
            swatchMap = [];
            _loc_7 = Math.min(1024, colors.length);
            _loc_8 = -1;
            _loc_9 = 0;
            while (_loc_9 < _loc_7)
            {
                
                _loc_10 = createSwatch(colors[_loc_9]);
                _loc_10.x = (_loc_5 + _loc_4) * (_loc_9 % _loc_3);
                if (_loc_10.x == 0)
                {
                    swatchMap.push([_loc_10]);
                    _loc_8++;
                }
                else
                {
                    swatchMap[_loc_8].push(_loc_10);
                }
                colorHash[colors[_loc_9]] = {swatch:_loc_10, row:_loc_8, col:(swatchMap[_loc_8].length - 1)};
                _loc_10.y = Math.floor(_loc_9 / _loc_3) * (_loc_6 + _loc_4);
                swatches.addChild(_loc_10);
                _loc_9 = _loc_9 + 1;
            }
            return;
        }// end function

        override protected function configUI() : void
        {
            var _loc_1:uint = 0;
            super.configUI();
            tabChildren = false;
            if (defaultColors == null)
            {
                defaultColors = [];
                _loc_1 = 0;
                while (_loc_1 < 216)
                {
                    
                    defaultColors.push(((_loc_1 / 6 % 3 << 0) + (_loc_1 / 108 << 0) * 3) * 51 << 16 | _loc_1 % 6 * 51 << 8 | (_loc_1 / 18 << 0) % 6 * 51);
                    _loc_1 = _loc_1 + 1;
                }
            }
            colorHash = {};
            swatchMap = [];
            textField = new TextField();
            textField.tabEnabled = false;
            swatchButton = new BaseButton();
            swatchButton.focusEnabled = false;
            swatchButton.useHandCursor = false;
            swatchButton.autoRepeat = false;
            swatchButton.setSize(25, 25);
            swatchButton.addEventListener(MouseEvent.CLICK, onPopupButtonClick, false, 0, true);
            addChild(swatchButton);
            palette = new Sprite();
            palette.tabChildren = false;
            palette.cacheAsBitmap = true;
            return;
        }// end function

        public function get showTextField() : Boolean
        {
            return _showTextField;
        }// end function

        public function get colors() : Array
        {
            return customColors != null ? (customColors) : (defaultColors);
        }// end function

        protected function findSwatch(param1:uint) : Sprite
        {
            var _loc_2:Object = null;
            if (!swatchMap.length)
            {
                return null;
            }
            _loc_2 = colorHash[param1];
            if (_loc_2 != null)
            {
                return _loc_2.swatch;
            }
            return null;
        }// end function

        protected function setColorDisplay() : void
        {
            var _loc_1:ColorTransform = null;
            var _loc_2:Sprite = null;
            if (!swatchMap.length)
            {
                return;
            }
            _loc_1 = new ColorTransform(0, 0, 0, 1, _selectedColor >> 16, _selectedColor >> 8 & 255, _selectedColor & 255, 0);
            setColorWellColor(_loc_1);
            setColorText(_selectedColor);
            _loc_2 = findSwatch(_selectedColor);
            setSwatchHighlight(_loc_2);
            if (swatchMap.length && colorHash[_selectedColor] == undefined)
            {
                cleanUpSelected();
            }
            return;
        }// end function

        protected function cleanUpSelected() : void
        {
            if (swatchSelectedSkin && palette.contains(swatchSelectedSkin))
            {
                palette.removeChild(swatchSelectedSkin);
            }
            return;
        }// end function

        public function get selectedColor() : uint
        {
            if (colorWell == null)
            {
                return 0;
            }
            return colorWell.transform.colorTransform.color;
        }// end function

        private function addCloseListener(event:Event)
        {
            removeEventListener(Event.ENTER_FRAME, addCloseListener);
            if (!isOpen)
            {
                return;
            }
            addStageListener();
            return;
        }// end function

        protected function removeStageListener(event:Event = null) : void
        {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageClick, false);
            return;
        }// end function

        protected function setStyles() : void
        {
            var _loc_1:DisplayObject = null;
            var _loc_2:Object = null;
            _loc_1 = colorWell;
            _loc_2 = getStyleValue("colorWell");
            if (_loc_2 != null)
            {
                colorWell = getDisplayObjectInstance(_loc_2) as DisplayObject;
            }
            addChildAt(colorWell, getChildIndex(swatchButton));
            copyStylesToChild(swatchButton, POPUP_BUTTON_STYLES);
            swatchButton.drawNow();
            if (_loc_1 != null && contains(_loc_1) && _loc_1 != colorWell)
            {
                removeChild(_loc_1);
            }
            return;
        }// end function

        public function close() : void
        {
            var _loc_1:IFocusManager = null;
            if (isOpen)
            {
                stage.removeChild(palette);
                isOpen = false;
                dispatchEvent(new Event(Event.CLOSE));
            }
            _loc_1 = focusManager;
            if (_loc_1)
            {
                _loc_1.defaultButtonEnabled = true;
            }
            removeStageListener();
            cleanUpSelected();
            return;
        }// end function

        public static function getStyleDefinition() : Object
        {
            return defaultStyles;
        }// end function

    }
}
