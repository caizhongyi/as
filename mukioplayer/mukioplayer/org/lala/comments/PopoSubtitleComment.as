package org.lala.comments
{
    import flash.display.*;
    import flash.text.*;

    public class PopoSubtitleComment extends Sprite
    {
        private var tf:TextFormat;
        private var item:Object;
        private var ttf:TextField;

        public function PopoSubtitleComment(param1:Object)
        {
            var _loc_2:String = null;
            this.item = {};
            for (_loc_2 in param1)
            {
                
                this.item[_loc_2] = param1[_loc_2];
            }
            this.init();
            return;
        }// end function

        private function init() : void
        {
            this.tf = this.getTextFormat();
            this.ttf = new TextField();
            this.ttf.autoSize = "left";
            this.ttf.defaultTextFormat = this.tf;
            var _loc_1:int = 0;
            this.ttf.y = 0;
            this.ttf.x = _loc_1;
            this.ttf.text = this.item.text;
            addChild(this.ttf);
            return;
        }// end function

        private function getTextFormat() : TextFormat
        {
            var _loc_1:* = new TextFormat();
            _loc_1.size = this.item.size;
            _loc_1.color = this.item.color;
            var _loc_2:* = this.item.tStyle;
            if (_loc_2.match("italic"))
            {
                _loc_1.italic = true;
            }
            if (_loc_2.match("bold"))
            {
                _loc_1.bold = true;
            }
            if (_loc_2.match("underline"))
            {
                _loc_1.underline = true;
            }
            return _loc_1;
        }// end function

        override public function get width() : Number
        {
            return this.ttf.width;
        }// end function

        override public function get height() : Number
        {
            return this.ttf.height;
        }// end function

        override public function set width(param1:Number) : void
        {
            super.width = param1;
            return;
        }// end function

    }
}
