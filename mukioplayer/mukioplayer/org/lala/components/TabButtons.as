package org.lala.components
{
    import fl.controls.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import org.lala.events.*;

    public class TabButtons extends EventDispatcher
    {
        private var tf2:TextFormat;
        private var SWidth:int = 400;
        private var tabsArr:Array;
        public var clip:Sprite;
        private var TWidth:int = 120;
        private var X0:int = 0;
        private var SHeight:int = 400;
        private var THeight:int = 27;
        private var tf:TextFormat;
        private var curTab:Object;
        private var Y0:int = 0;

        public function TabButtons(param1:Sprite, param2:int, param3:int, param4:int, param5:int) : void
        {
            this.tabsArr = [];
            this.clip = param1;
            this.X0 = param2;
            this.Y0 = param3;
            this.SWidth = param4;
            this.SHeight = param5;
            this.tf = new TextFormat("simsum", "12", 3289650);
            this.tf2 = new TextFormat("simsum", "12", 6447714);
            return;
        }// end function

        public function addItem(param1:int, param2:DisplayObject) : void
        {
            if (param1 >= this.tabsArr.length)
            {
                return;
            }
            this.tabsArr[param1].fd.addChild(param2);
            return;
        }// end function

        public function tab(param1:int) : Sprite
        {
            if (param1 >= this.tabsArr.length)
            {
                return null;
            }
            return this.tabsArr[param1].fd;
        }// end function

        public function bt(param1:int) : Button
        {
            if (param1 >= this.tabsArr.length)
            {
                return null;
            }
            return this.tabsArr[param1].bt;
        }// end function

        public function addTab(param1:String, param2:int = 14540287) : void
        {
            var _loc_3:Button = null;
            var _loc_4:Sprite = null;
            _loc_3 = new Button();
            _loc_4 = new Sprite();
            _loc_3.setStyle("selectedUpSkin", Button_selectedDownSkin);
            _loc_3.setStyle("selectedDisabledSkin", Button_upSkin);
            _loc_3.label = param1;
            _loc_3.move(this.X0 + (this.TWidth + 2) * this.tabsArr.length + 1, this.Y0 + 3);
            _loc_3.setSize(this.TWidth, this.THeight);
            _loc_3.setStyle("textFormat", this.tf2);
            _loc_3.setStyle("disabledTextFormat", this.tf);
            _loc_3.toggle = true;
            _loc_3.selected = true;
            _loc_3.addEventListener(Event.CHANGE, this.changeHandler);
            this.clip.addChildAt(_loc_3, 0);
            var _loc_5:int = 1;
            _loc_4.scaleY = 1;
            _loc_4.scaleX = _loc_5;
            _loc_4.graphics.beginFill(param2);
            _loc_4.graphics.drawRect(0, -2, this.SWidth, this.SHeight);
            _loc_4.graphics.endFill();
            _loc_4.graphics.lineStyle(1, 7370362);
            _loc_4.graphics.moveTo(0, -2);
            _loc_4.graphics.lineTo(1 + this.tabsArr.length * (this.TWidth + 2), -2);
            _loc_4.graphics.moveTo(1 + this.tabsArr.length * (this.TWidth + 2) + this.TWidth, -2);
            _loc_4.graphics.lineTo(this.SWidth, -2);
            _loc_4.x = this.X0;
            _loc_4.y = this.Y0 + this.THeight;
            _loc_4.visible = false;
            this.clip.addChild(_loc_4);
            this.tabsArr.push({bt:_loc_3, fd:_loc_4});
            if (this.tabsArr.length == 1)
            {
                this.curTab = this.tabsArr[0];
                this.curTab.bt.enabled = false;
                this.curTab.bt.selected = true;
                this.curTab.fd.visible = true;
            }
            return;
        }// end function

        private function changeHandler(event:Event) : void
        {
            var _loc_2:* = event.target as Button;
            var _loc_3:int = 0;
            while (_loc_3 < this.tabsArr.length)
            {
                
                if (this.tabsArr[_loc_3].bt == _loc_2)
                {
                    this.curTab.bt.enabled = true;
                    this.curTab.bt.selected = true;
                    this.curTab.fd.visible = false;
                    this.curTab = this.tabsArr[_loc_3];
                    this.curTab.bt.enabled = false;
                    this.curTab.bt.selected = true;
                    this.curTab.fd.visible = true;
                    dispatchEvent(new CommentListViewEvent(CommentListViewEvent.TBBUTTONCHANGE, _loc_3));
                    break;
                }
                _loc_3++;
            }
            return;
        }// end function

        public function set selectedIndex(param1:int) : void
        {
            if (param1 >= this.tabsArr.length)
            {
                return;
            }
            this.curTab.bt.enabled = true;
            this.curTab.bt.selected = true;
            this.curTab.fd.visible = false;
            this.curTab = this.tabsArr[param1];
            this.curTab.bt.enabled = false;
            this.curTab.bt.selected = true;
            this.curTab.fd.visible = true;
            dispatchEvent(new CommentListViewEvent(CommentListViewEvent.TBBUTTONCHANGE, param1));
            return;
        }// end function

    }
}
