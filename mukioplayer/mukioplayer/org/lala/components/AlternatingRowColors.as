package org.lala.components
{
    import fl.controls.listClasses.*;

    public class AlternatingRowColors extends CellRenderer implements ICellRenderer
    {

        public function AlternatingRowColors()
        {
            return;
        }// end function

        override protected function drawBackground() : void
        {
            if (_listData.index % 2 == 0)
            {
                setStyle("upSkin", CellRenderer_upSkin);
            }
            else
            {
                setStyle("upSkin", CellRenderer_upSkinBlue);
            }
            super.drawBackground();
            return;
        }// end function

        public static function getStyleDefinition() : Object
        {
            return CellRenderer.getStyleDefinition();
        }// end function

    }
}
