package org.lala.comments
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class TextPool extends EventDispatcher
    {
        private var freeList:Array;
        private var clip:Sprite;
        private var tList:Array;
        public var totle:int = 0;
        public static var STEP:int = 20;
        public static var MAX:int = 100;

        public function TextPool(param1:Sprite)
        {
            this.tList = [];
            this.freeList = [];
            this.clip = param1;
            return;
        }// end function

        public function get onstage() : int
        {
            return this.totle - this.freeList.length;
        }// end function

        public function set txt(param1:TextField) : void
        {
            param1.visible = false;
            this.clip.setChildIndex(param1, 0);
            this.freeList.push(param1);
            return;
        }// end function

        public function get txt() : TextField
        {
            var _loc_1:TextField = null;
            if (this.freeList.length <= 1)
            {
                this.expand(STEP);
            }
            _loc_1 = this.freeList.pop();
            this.clip.setChildIndex(_loc_1, (this.clip.numChildren - 1));
            _loc_1.visible = true;
            return _loc_1;
        }// end function

        private function newtxt() : TextField
        {
            var _loc_1:* = new TextField();
            _loc_1.visible = false;
            this.clip.addChild(_loc_1);
            this.tList.push(_loc_1);
            this.freeList.push(_loc_1);
            var _loc_2:String = this;
            var _loc_3:* = this.totle + 1;
            _loc_2.totle = _loc_3;
            return _loc_1;
        }// end function

        private function expand(param1:int) : void
        {
            trace("tp expand : ");
            while (param1 > 0)
            {
                
                this.newtxt();
                param1 = param1 - 1;
            }
            return;
        }// end function

        public function init() : void
        {
            trace("tp init : ");
            this.expand(MAX);
            return;
        }// end function

    }
}
