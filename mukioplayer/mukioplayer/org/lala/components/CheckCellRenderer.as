package org.lala.components
{
    import fl.controls.listClasses.*;
    import flash.events.*;
    import flash.utils.*;

    public class CheckCellRenderer extends CellRenderer
    {
        private var _sel:Boolean;
        private var unSelSkins:Array;
        private var SelSkins:Array;

        public function CheckCellRenderer()
        {
            this.SelSkins = [];
            this.unSelSkins = [];
            this.loadSkins();
            addEventListener(MouseEvent.CLICK, this.clHandler);
            return;
        }// end function

        private function clHandler(event:MouseEvent) : void
        {
            this._sel = !this._sel;
            super.data.enable = this._sel;
            this.updateSkins();
            return;
        }// end function

        private function getAClassObject(param1:String) : Object
        {
            var _loc_2:* = getDefinitionByName(param1) as Class;
            return new _loc_2;
        }// end function

        private function updateSkins() : void
        {
            super.label = this._sel ? ("∆Ù”√") : (" Œ¥∆Ù”√");
            var _loc_1:int = 0;
            while (_loc_1 < 5)
            {
                
                if (this._sel)
                {
                    super.setStyle(this.SelSkins[_loc_1].name, this.SelSkins[_loc_1].data);
                }
                else
                {
                    super.setStyle(this.unSelSkins[_loc_1].name, this.unSelSkins[_loc_1].data);
                }
                _loc_1++;
            }
            return;
        }// end function

        private function loadSkins() : void
        {
            var _loc_1:Array = ["up", "down", "over", "disabled"];
            var _loc_2:Array = ["Up", "Down", "Over", "Disabled"];
            var _loc_3:int = 0;
            while (_loc_3 < 4)
            {
                
                this.SelSkins.push({name:_loc_1[_loc_3] + "Icon", data:this.getAClassObject("CheckBox_selected" + _loc_2[_loc_3] + "Icon")});
                this.unSelSkins.push({name:_loc_1[_loc_3] + "Icon", data:this.getAClassObject("CheckBox_" + _loc_1[_loc_3] + "Icon")});
                _loc_3++;
            }
            this.SelSkins.push({name:"icon", data:this.SelSkins[0].data});
            this.unSelSkins.push({name:"icon", data:this.unSelSkins[0].data});
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

        override public function set data(param1:Object) : void
        {
            super.data = param1;
            this._sel = param1.enable;
            return;
        }// end function

        override public function set listData(param1:ListData) : void
        {
            super.listData = param1;
            this.updateSkins();
            return;
        }// end function

    }
}
