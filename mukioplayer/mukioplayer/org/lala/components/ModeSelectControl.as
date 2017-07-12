package org.lala.components
{
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import org.lala.events.*;

    public class ModeSelectControl extends ModeSelect
    {
        protected var _mode:int = 1;
        protected var colorrect:Sprite;
        protected var _ref:InteractiveObject;
        protected var moderect:Sprite;
        protected var clrbtArray:Array;
        protected var _size:int = 25;
        protected var _color:int = 16777215;
        protected var sizerect:Sprite;
        protected var clrArray:Array;

        public function ModeSelectControl()
        {
            this.clrArray = [16777215, 16711680, 16744576, 16760832, 16776960, 65280, 65535, 255, 12583167, 0, 13421721, 13369395, 16724940, 16737792, 10066176, 52326, 52428, 3381759, 10027263, 6710886];
            this.clrbtArray = [];
            this.addColorButtons();
            this.moderect = new Sprite();
            this.moderect.graphics.lineStyle(2, 3355443, 1, false, "normal", CapsStyle.NONE, JointStyle.MITER);
            this.moderect.graphics.drawRect(0, 0, 57, 41);
            addChild(this.moderect);
            this.sizerect = new Sprite();
            this.sizerect.graphics.lineStyle(2, 3355443, 1, false, "normal", CapsStyle.NONE, JointStyle.MITER);
            this.sizerect.graphics.drawRect(0, 0, 57, 41);
            addChild(this.sizerect);
            this.colorrect = new Sprite();
            this.colorrect.graphics.lineStyle(2, 3355443, 1, false, "normal", CapsStyle.NONE, JointStyle.MITER);
            this.colorrect.graphics.drawRect(0, 0, 15.5, 15.5);
            addChild(this.colorrect);
            this.addModeButton(leftflowbt, 1);
            this.addModeButton(bottommodebt, 4);
            this.addModeButton(topmodebt, 5);
            this.addSizeButton(normalsizebt, 25);
            this.addSizeButton(smallsizebt, 15);
            this.addSizeButton(bigsizebt, 37);
            resetbt.addEventListener(MouseEvent.CLICK, this.resetAll);
            this.resetAll();
            closebt.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) : void
            {
                visible = false;
                removeEventListener(MouseEvent.CLICK, stageClickHandler);
                return;
            }// end function
            );
            this.init();
            return;
        }// end function

        public function get size() : int
        {
            return this._size;
        }// end function

        protected function setSize(param1:SimpleButton, param2:int) : void
        {
            this._size = param2;
            this.sizerect.x = param1.x - 0.5;
            this.sizerect.y = param1.y - 0.5;
            this.changed("size", param2);
            return;
        }// end function

        private function stageClickHandler(event:MouseEvent) : void
        {
            if (!hitTestPoint(event.stageX, event.stageY) && !this._ref.hitTestPoint(event.stageX, event.stageY))
            {
                visible = false;
                removeEventListener(MouseEvent.CLICK, this.stageClickHandler);
            }
            return;
        }// end function

        protected function init() : void
        {
            visible = false;
            filters = [new DropShadowFilter(2, 45, 0, 0.6)];
            return;
        }// end function

        protected function resetAll(event:MouseEvent = null) : void
        {
            this.setMode(leftflowbt, 1);
            this.setSize(normalsizebt, 25);
            this.setColor(this.clrbtArray[0], this.clrArray[0]);
            return;
        }// end function

        protected function addSizeButton(param1:SimpleButton, param2:int) : void
        {
            var bt:* = param1;
            var sz:* = param2;
            bt.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) : void
            {
                setSize(bt, sz);
                return;
            }// end function
            );
            return;
        }// end function

        private function refClickHandler(event:MouseEvent) : void
        {
            this.show();
            return;
        }// end function

        protected function addColorButtons() : void
        {
            var _loc_5:ColorCellButton = null;
            var _loc_1:int = 0;
            var _loc_2:int = 10;
            var _loc_3:int = 60;
            var _loc_4:int = 23;
            _loc_1 = 0;
            while (_loc_1 < this.clrArray.length)
            {
                
                _loc_5 = new ColorCellButton(this.clrArray[_loc_1]);
                _loc_5.x = _loc_3 + 18 * (_loc_1 % _loc_2);
                _loc_5.y = _loc_4 + 18 * Math.floor(_loc_1 / _loc_2);
                this.addColorButton(_loc_5, this.clrArray[_loc_1]);
                addChild(_loc_5);
                this.clrbtArray.push(_loc_5);
                _loc_1++;
            }
            return;
        }// end function

        protected function setColor(param1:SimpleButton, param2:int) : void
        {
            this._color = param2;
            this.colorrect.x = param1.x + 0.5;
            this.colorrect.y = param1.y + 0.5;
            this.changed("color", param2);
            return;
        }// end function

        protected function addColorButton(param1:SimpleButton, param2:int) : void
        {
            var bt:* = param1;
            var clr:* = param2;
            bt.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) : void
            {
                setColor(bt, clr);
                return;
            }// end function
            );
            return;
        }// end function

        public function set ref(param1:InteractiveObject) : void
        {
            this._ref = param1;
            param1.addEventListener(MouseEvent.CLICK, this.refClickHandler);
            return;
        }// end function

        public function get mode() : int
        {
            return this._mode;
        }// end function

        protected function setMode(param1:SimpleButton, param2:int) : void
        {
            this._mode = param2;
            this.moderect.x = param1.x - 0.5;
            this.moderect.y = param1.y - 0.5;
            this.changed("mode", param2);
            return;
        }// end function

        public function get color() : int
        {
            return this._color;
        }// end function

        protected function changed(param1:String, param2:int) : void
        {
            dispatchEvent(new CommentListViewEvent(CommentListViewEvent.MODESTYLESIZECHANGE, {type:param1, value:param2}));
            return;
        }// end function

        protected function addModeButton(param1:SimpleButton, param2:int) : void
        {
            var bt:* = param1;
            var mod:* = param2;
            bt.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) : void
            {
                setMode(bt, mod);
                return;
            }// end function
            );
            return;
        }// end function

        public function show() : void
        {
            if (visible)
            {
                visible = false;
                removeEventListener(MouseEvent.CLICK, this.stageClickHandler);
                return;
            }
            visible = true;
            stage.addEventListener(MouseEvent.CLICK, this.stageClickHandler);
            return;
        }// end function

    }
}
