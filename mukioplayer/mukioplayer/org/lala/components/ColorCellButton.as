package org.lala.components
{
    import flash.display.*;

    public class ColorCellButton extends SimpleButton
    {

        public function ColorCellButton(param1:int)
        {
            var _loc_2:* = this.getColorIcon(param1);
            super(_loc_2, _loc_2, _loc_2, _loc_2);
            var _loc_3:* = _loc_2.width;
            height = _loc_2.width;
            width = _loc_3;
            return;
        }// end function

        protected function getColorIcon(param1:int) : DisplayObject
        {
            var _loc_2:* = new BClrCell();
            _loc_2.graphics.beginFill(param1);
            _loc_2.graphics.drawRect(4, 4, 10, 10);
            _loc_2.graphics.endFill();
            return _loc_2;
        }// end function

    }
}
