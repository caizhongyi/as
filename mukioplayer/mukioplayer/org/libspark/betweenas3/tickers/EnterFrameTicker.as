package org.libspark.betweenas3.tickers
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    import org.libspark.betweenas3.core.ticker.*;

    public class EnterFrameTicker extends Object implements ITicker
    {
        private var _tickerListenerPaddings:Vector.<TickerListener>;
        private var _time:Number;
        private var _first:TickerListener = null;
        private var _last:TickerListener = null;
        private var _numListeners:uint = 0;
        private static var _shape:Shape = new Shape();

        public function EnterFrameTicker()
        {
            var _loc_3:TickerListener = null;
            this._tickerListenerPaddings = new Vector.<TickerListener>(10, true);
            var _loc_1:TickerListener = null;
            var _loc_2:uint = 0;
            while (_loc_2 < 10)
            {
                
                _loc_3 = new TickerListener();
                if (_loc_1 != null)
                {
                    _loc_1.nextListener = _loc_3;
                    _loc_3.prevListener = _loc_1;
                }
                _loc_1 = _loc_3;
                this._tickerListenerPaddings[_loc_2] = _loc_3;
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        function update(event:Event) : void
        {
            var _loc_8:* = getTimer() / 1000;
            this._time = getTimer() / 1000;
            var _loc_2:* = _loc_8;
            var _loc_3:* = this._numListeners / 8 + 1 | 0;
            var _loc_4:* = _loc_3 * 8 - this._numListeners;
            var _loc_5:* = this._tickerListenerPaddings[0];
            var _loc_6:* = this._tickerListenerPaddings[_loc_4];
            var _loc_7:TickerListener = null;
            var _loc_8:* = this._first;
            _loc_6.nextListener = this._first;
            if (_loc_8 != null)
            {
                this._first.prevListener = _loc_6;
            }
            while (--_loc_3 >= 0)
            {
                
                var _loc_8:* = _loc_5.nextListener;
                _loc_5 = _loc_5.nextListener;
                if (_loc_8.tick(_loc_2))
                {
                    if (_loc_5.prevListener != null)
                    {
                        _loc_5.prevListener.nextListener = _loc_5.nextListener;
                    }
                    if (_loc_5.nextListener != null)
                    {
                        _loc_5.nextListener.prevListener = _loc_5.prevListener;
                    }
                    if (_loc_5 == this._first)
                    {
                        this._first = _loc_5.nextListener;
                    }
                    if (_loc_5 == this._last)
                    {
                        this._last = _loc_5.prevListener;
                    }
                    _loc_7 = _loc_5.prevListener;
                    _loc_5.nextListener = null;
                    _loc_5.prevListener = null;
                    _loc_5 = _loc_7;
                    var _loc_8:String = this;
                    var _loc_9:* = this._numListeners - 1;
                    _loc_8._numListeners = _loc_9;
                }
                var _loc_8:* = _loc_5.nextListener;
                _loc_5 = _loc_5.nextListener;
                if (_loc_8.tick(_loc_2))
                {
                    if (_loc_5.prevListener != null)
                    {
                        _loc_5.prevListener.nextListener = _loc_5.nextListener;
                    }
                    if (_loc_5.nextListener != null)
                    {
                        _loc_5.nextListener.prevListener = _loc_5.prevListener;
                    }
                    if (_loc_5 == this._first)
                    {
                        this._first = _loc_5.nextListener;
                    }
                    if (_loc_5 == this._last)
                    {
                        this._last = _loc_5.prevListener;
                    }
                    _loc_7 = _loc_5.prevListener;
                    _loc_5.nextListener = null;
                    _loc_5.prevListener = null;
                    _loc_5 = _loc_7;
                    var _loc_8:String = this;
                    var _loc_9:* = this._numListeners - 1;
                    _loc_8._numListeners = _loc_9;
                }
                var _loc_8:* = _loc_5.nextListener;
                _loc_5 = _loc_5.nextListener;
                if (_loc_8.tick(_loc_2))
                {
                    if (_loc_5.prevListener != null)
                    {
                        _loc_5.prevListener.nextListener = _loc_5.nextListener;
                    }
                    if (_loc_5.nextListener != null)
                    {
                        _loc_5.nextListener.prevListener = _loc_5.prevListener;
                    }
                    if (_loc_5 == this._first)
                    {
                        this._first = _loc_5.nextListener;
                    }
                    if (_loc_5 == this._last)
                    {
                        this._last = _loc_5.prevListener;
                    }
                    _loc_7 = _loc_5.prevListener;
                    _loc_5.nextListener = null;
                    _loc_5.prevListener = null;
                    _loc_5 = _loc_7;
                    var _loc_8:String = this;
                    var _loc_9:* = this._numListeners - 1;
                    _loc_8._numListeners = _loc_9;
                }
                var _loc_8:* = _loc_5.nextListener;
                _loc_5 = _loc_5.nextListener;
                if (_loc_8.tick(_loc_2))
                {
                    if (_loc_5.prevListener != null)
                    {
                        _loc_5.prevListener.nextListener = _loc_5.nextListener;
                    }
                    if (_loc_5.nextListener != null)
                    {
                        _loc_5.nextListener.prevListener = _loc_5.prevListener;
                    }
                    if (_loc_5 == this._first)
                    {
                        this._first = _loc_5.nextListener;
                    }
                    if (_loc_5 == this._last)
                    {
                        this._last = _loc_5.prevListener;
                    }
                    _loc_7 = _loc_5.prevListener;
                    _loc_5.nextListener = null;
                    _loc_5.prevListener = null;
                    _loc_5 = _loc_7;
                    var _loc_8:String = this;
                    var _loc_9:* = this._numListeners - 1;
                    _loc_8._numListeners = _loc_9;
                }
                var _loc_8:* = _loc_5.nextListener;
                _loc_5 = _loc_5.nextListener;
                if (_loc_8.tick(_loc_2))
                {
                    if (_loc_5.prevListener != null)
                    {
                        _loc_5.prevListener.nextListener = _loc_5.nextListener;
                    }
                    if (_loc_5.nextListener != null)
                    {
                        _loc_5.nextListener.prevListener = _loc_5.prevListener;
                    }
                    if (_loc_5 == this._first)
                    {
                        this._first = _loc_5.nextListener;
                    }
                    if (_loc_5 == this._last)
                    {
                        this._last = _loc_5.prevListener;
                    }
                    _loc_7 = _loc_5.prevListener;
                    _loc_5.nextListener = null;
                    _loc_5.prevListener = null;
                    _loc_5 = _loc_7;
                    var _loc_8:String = this;
                    var _loc_9:* = this._numListeners - 1;
                    _loc_8._numListeners = _loc_9;
                }
                var _loc_8:* = _loc_5.nextListener;
                _loc_5 = _loc_5.nextListener;
                if (_loc_8.tick(_loc_2))
                {
                    if (_loc_5.prevListener != null)
                    {
                        _loc_5.prevListener.nextListener = _loc_5.nextListener;
                    }
                    if (_loc_5.nextListener != null)
                    {
                        _loc_5.nextListener.prevListener = _loc_5.prevListener;
                    }
                    if (_loc_5 == this._first)
                    {
                        this._first = _loc_5.nextListener;
                    }
                    if (_loc_5 == this._last)
                    {
                        this._last = _loc_5.prevListener;
                    }
                    _loc_7 = _loc_5.prevListener;
                    _loc_5.nextListener = null;
                    _loc_5.prevListener = null;
                    _loc_5 = _loc_7;
                    var _loc_8:String = this;
                    var _loc_9:* = this._numListeners - 1;
                    _loc_8._numListeners = _loc_9;
                }
                var _loc_8:* = _loc_5.nextListener;
                _loc_5 = _loc_5.nextListener;
                if (_loc_8.tick(_loc_2))
                {
                    if (_loc_5.prevListener != null)
                    {
                        _loc_5.prevListener.nextListener = _loc_5.nextListener;
                    }
                    if (_loc_5.nextListener != null)
                    {
                        _loc_5.nextListener.prevListener = _loc_5.prevListener;
                    }
                    if (_loc_5 == this._first)
                    {
                        this._first = _loc_5.nextListener;
                    }
                    if (_loc_5 == this._last)
                    {
                        this._last = _loc_5.prevListener;
                    }
                    _loc_7 = _loc_5.prevListener;
                    _loc_5.nextListener = null;
                    _loc_5.prevListener = null;
                    _loc_5 = _loc_7;
                    var _loc_8:String = this;
                    var _loc_9:* = this._numListeners - 1;
                    _loc_8._numListeners = _loc_9;
                }
                var _loc_8:* = _loc_5.nextListener;
                _loc_5 = _loc_5.nextListener;
                if (_loc_8.tick(_loc_2))
                {
                    if (_loc_5.prevListener != null)
                    {
                        _loc_5.prevListener.nextListener = _loc_5.nextListener;
                    }
                    if (_loc_5.nextListener != null)
                    {
                        _loc_5.nextListener.prevListener = _loc_5.prevListener;
                    }
                    if (_loc_5 == this._first)
                    {
                        this._first = _loc_5.nextListener;
                    }
                    if (_loc_5 == this._last)
                    {
                        this._last = _loc_5.prevListener;
                    }
                    _loc_7 = _loc_5.prevListener;
                    _loc_5.nextListener = null;
                    _loc_5.prevListener = null;
                    _loc_5 = _loc_7;
                    var _loc_8:String = this;
                    var _loc_9:* = this._numListeners - 1;
                    _loc_8._numListeners = _loc_9;
                }
            }
            var _loc_8:* = _loc_6.nextListener;
            this._first = _loc_6.nextListener;
            if (_loc_8 != null)
            {
                this._first.prevListener = null;
            }
            else
            {
                this._last = null;
            }
            _loc_6.nextListener = this._tickerListenerPaddings[(_loc_4 + 1)];
            return;
        }// end function

        public function start() : void
        {
            this._time = getTimer() / 1000;
            _shape.addEventListener(Event.ENTER_FRAME, this.update);
            return;
        }// end function

        public function removeTickerListener(param1:TickerListener) : void
        {
            var _loc_2:* = this._first;
            while (_loc_2 != null)
            {
                
                if (_loc_2 == param1)
                {
                    if (_loc_2.prevListener != null)
                    {
                        _loc_2.prevListener.nextListener = _loc_2.nextListener;
                        _loc_2.nextListener = null;
                    }
                    else
                    {
                        this._first = _loc_2.nextListener;
                    }
                    if (_loc_2.nextListener != null)
                    {
                        _loc_2.nextListener.prevListener = _loc_2.prevListener;
                        _loc_2.prevListener = null;
                    }
                    else
                    {
                        this._last = _loc_2.prevListener;
                    }
                    var _loc_3:String = this;
                    var _loc_4:* = this._numListeners - 1;
                    _loc_3._numListeners = _loc_4;
                }
                _loc_2 = _loc_2.nextListener;
            }
            return;
        }// end function

        public function get time() : Number
        {
            return this._time;
        }// end function

        public function addTickerListener(param1:TickerListener) : void
        {
            if (param1.nextListener != null || param1.prevListener != null)
            {
                return;
            }
            if (this._last != null)
            {
                if (this._last.nextListener != null)
                {
                    this._last.nextListener.prevListener = param1;
                    param1.nextListener = this._last.nextListener;
                }
                param1.prevListener = this._last;
                this._last.nextListener = param1;
            }
            this._last = param1;
            if (this._first == null)
            {
                this._first = param1;
            }
            var _loc_2:String = this;
            var _loc_3:* = this._numListeners + 1;
            _loc_2._numListeners = _loc_3;
            return;
        }// end function

        public function stop() : void
        {
            _shape.removeEventListener(Event.ENTER_FRAME, this.update);
            return;
        }// end function

    }
}
