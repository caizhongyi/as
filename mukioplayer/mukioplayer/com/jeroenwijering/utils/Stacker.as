package com.jeroenwijering.utils
{
    import flash.display.*;

    public class Stacker extends Object
    {
        private var _width:Number;
        private var stack:Array;
        public var clip:MovieClip;
        private var latest:Number = 0;

        public function Stacker(param1:MovieClip) : void
        {
            this.clip = param1;
            this.analyze();
            return;
        }// end function

        public function get width() : Number
        {
            return this._width;
        }// end function

        private function overlaps(param1:Number) : Boolean
        {
            var _loc_2:* = this.stack[param1].x;
            var _loc_3:* = this.stack[param1].x + this.stack[param1].w;
            var _loc_4:Number = 0;
            while (_loc_4 < this.stack.length)
            {
                
                if (_loc_4 != param1 && this.stack[_loc_4].c.visible == true && this.stack[_loc_4].w < this._width && this.stack[_loc_4].x < _loc_3 && this.stack[_loc_4].x + this.stack[_loc_4].w > _loc_2)
                {
                    return true;
                }
                _loc_4 = _loc_4 + 1;
            }
            return false;
        }// end function

        public function insert(param1:MovieClip, param2:MovieClip) : void
        {
            var _loc_3:Number = 0;
            var _loc_4:Number = 0;
            while (_loc_4 < this.stack.length)
            {
                
                if (this.stack[_loc_4].w >= this._width)
                {
                    this.stack[_loc_4].w = this.stack[_loc_4].w + param1.width;
                }
                if (this.stack[_loc_4].c == param2 && !_loc_3)
                {
                    _loc_3 = _loc_4;
                    this.stack.splice(_loc_4, 0, {c:param1, x:this.stack[_loc_4].x, n:param1.name, w:param1.width});
                }
                else if (_loc_3)
                {
                    this.stack[_loc_4].x = this.stack[_loc_4].x + param1.width;
                }
                _loc_4 = _loc_4 + 1;
            }
            this._width = this._width + param1.width;
            this.rearrange();
            return;
        }// end function

        public function rearrange(param1:Number = ) : void
        {
            var _loc_6:Number = NaN;
            if (param1)
            {
                this.latest = param1;
            }
            var _loc_2:* = this.latest - this.width;
            var _loc_3:Number = 0;
            var _loc_4:Number = 0;
            while (_loc_4 < this.stack.length)
            {
                
                if (this.stack[_loc_4].x > this.width / 2)
                {
                    this.stack[_loc_4].c.x = this.stack[_loc_4].x + _loc_2;
                    if (this.stack[_loc_4].c.visible == false && this.overlaps(_loc_4) == false)
                    {
                        if (_loc_4 < (this.stack.length - 1))
                        {
                            _loc_2 = _loc_2 - (this.stack[_loc_4].w + this.stack[_loc_4].x - this.stack[(_loc_4 - 1)].x - this.stack[(_loc_4 - 1)].w);
                        }
                        else
                        {
                            _loc_2 = _loc_2 - (this.stack[_loc_4].w + this.stack[_loc_4].x - this.stack[(_loc_4 - 1)].x - this.stack[(_loc_4 - 1)].w);
                        }
                    }
                }
                else
                {
                    this.stack[_loc_4].c.x = this.stack[_loc_4].x - _loc_3;
                    if (this.stack[_loc_4].c.visible == false && this.overlaps(_loc_4) == false)
                    {
                        if (this.stack[(_loc_4 - 1)].w > this.width / 4)
                        {
                            _loc_3 = _loc_3 + (this.stack[_loc_4].w + this.stack[_loc_4].x);
                        }
                        else
                        {
                            _loc_3 = _loc_3 + (this.stack[_loc_4].w + this.stack[_loc_4].x - this.stack[(_loc_4 - 1)].x - this.stack[(_loc_4 - 1)].w);
                        }
                    }
                }
                if (this.stack[_loc_4].w > this.width / 4)
                {
                    this.stack[_loc_4].c.width = Math.abs(this.stack[_loc_4].w + _loc_2 + _loc_3);
                }
                _loc_4 = _loc_4 + 1;
            }
            var _loc_5:* = this.latest - this.width - _loc_2;
            if (this.latest - this.width - _loc_2 > 0)
            {
                _loc_6 = 0;
                while (_loc_6 < this.stack.length)
                {
                    
                    if (this.stack[_loc_6].x > this.width / 2)
                    {
                        this.stack[_loc_6].c.x = this.stack[_loc_6].c.x + _loc_5;
                    }
                    if (this.stack[_loc_6].w > this.width / 4 && this.stack[_loc_6].w < this.width)
                    {
                        this.stack[_loc_6].c.width = this.stack[_loc_6].c.width + _loc_5;
                    }
                    _loc_6 = _loc_6 + 1;
                }
            }
            return;
        }// end function

        private function analyze() : void
        {
            var _loc_2:DisplayObject = null;
            this._width = this.clip.width;
            this.stack = new Array();
            var _loc_1:Number = 0;
            while (_loc_1 < this.clip.numChildren)
            {
                
                _loc_2 = this.clip.getChildAt(_loc_1);
                this.stack.push({c:_loc_2, x:_loc_2.x, n:_loc_2.name, w:_loc_2.width});
                _loc_1 = _loc_1 + 1;
            }
            this.stack.sortOn(["x", "n"], [Array.NUMERIC, Array.CASEINSENSITIVE]);
            return;
        }// end function

    }
}
