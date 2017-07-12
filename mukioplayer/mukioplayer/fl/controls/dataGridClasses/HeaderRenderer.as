package fl.controls.dataGridClasses
{
    import fl.controls.*;

    public class HeaderRenderer extends LabelButton
    {
        public var _column:uint;
        private static var defaultStyles:Object = {upSkin:"HeaderRenderer_upSkin", downSkin:"HeaderRenderer_downSkin", overSkin:"HeaderRenderer_overSkin", disabledSkin:"HeaderRenderer_disabledSkin", selectedDisabledSkin:"HeaderRenderer_selectedDisabledSkin", selectedUpSkin:"HeaderRenderer_selectedUpSkin", selectedDownSkin:"HeaderRenderer_selectedDownSkin", selectedOverSkin:"HeaderRenderer_selectedOverSkin", textFormat:null, disabledTextFormat:null, textPadding:5};

        public function HeaderRenderer() : void
        {
            focusEnabled = false;
            return;
        }// end function

        public function set column(param1:uint) : void
        {
            _column = param1;
            return;
        }// end function

        public function get column() : uint
        {
            return _column;
        }// end function

        override protected function drawLayout() : void
        {
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            _loc_1 = Number(getStyleValue("textPadding"));
            textField.height = textField.textHeight + 4;
            textField.visible = label.length > 0;
            _loc_2 = textField.textWidth + 4;
            _loc_3 = textField.textHeight + 4;
            _loc_4 = icon == null ? (0) : (icon.width + 4);
            _loc_5 = Math.max(0, Math.min(_loc_2, width - 2 * _loc_1 - _loc_4));
            if (icon != null)
            {
                icon.x = width - _loc_1 - icon.width - 2;
                icon.y = Math.round((height - icon.height) / 2);
            }
            textField.width = _loc_5;
            textField.x = _loc_1;
            textField.y = Math.round((height - textField.height) / 2);
            background.width = width;
            background.height = height;
            return;
        }// end function

        public static function getStyleDefinition() : Object
        {
            return defaultStyles;
        }// end function

    }
}
