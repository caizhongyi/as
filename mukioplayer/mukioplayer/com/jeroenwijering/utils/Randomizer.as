package com.jeroenwijering.utils
{

    public class Randomizer extends Object
    {
        private var original:Array;
        private var todo:Array;
        private var done:Array;

        public function Randomizer(param1:Number) : void
        {
            this.original = new Array();
            this.todo = new Array();
            this.done = new Array();
            var _loc_2:Number = 0;
            while (_loc_2 < param1)
            {
                
                this.original.push(_loc_2);
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        public function back() : Number
        {
            if (this.done.length < 2)
            {
                return this.pick();
            }
            this.todo.push(this.done.pop());
            return this.done[(this.done.length - 1)];
        }// end function

        public function pick() : Number
        {
            var _loc_3:Number = NaN;
            if (this.todo.length == 0)
            {
                _loc_3 = 0;
                while (_loc_3 < this.original.length)
                {
                    
                    this.todo.push(_loc_3);
                    _loc_3 = _loc_3 + 1;
                }
            }
            var _loc_1:* = Math.floor(Math.random() * this.todo.length);
            var _loc_2:* = this.todo[_loc_1];
            this.done.push(this.todo.splice(_loc_1, 1)[0]);
            return _loc_2;
        }// end function

        public function get length() : Number
        {
            return this.todo.length;
        }// end function

    }
}
