package fl.controls.dataGridClasses
{
    import fl.controls.*;
    import fl.controls.listClasses.*;

    public class DataGridCellEditor extends TextInput implements ICellRenderer
    {
        protected var _data:Object;
        protected var _listData:ListData;
        private static var defaultStyles:Object = {textPadding:1, textFormat:null, upSkin:"DataGridCellEditor_skin"};

        public function DataGridCellEditor() : void
        {
            return;
        }// end function

        public function get selected() : Boolean
        {
            return false;
        }// end function

        public function set listData(param1:ListData) : void
        {
            _listData = param1;
            text = _listData.label;
            return;
        }// end function

        public function setMouseState(param1:String) : void
        {
            return;
        }// end function

        public function set selected(param1:Boolean) : void
        {
            return;
        }// end function

        public function set data(param1:Object) : void
        {
            _data = param1;
            return;
        }// end function

        public function get listData() : ListData
        {
            return _listData;
        }// end function

        public function get data() : Object
        {
            return _data;
        }// end function

        public static function getStyleDefinition() : Object
        {
            return defaultStyles;
        }// end function

    }
}
