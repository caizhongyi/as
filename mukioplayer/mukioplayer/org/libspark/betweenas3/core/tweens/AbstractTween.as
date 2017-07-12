package org.libspark.betweenas3.core.tweens
{
    import flash.events.*;
    import org.libspark.betweenas3.core.ticker.*;
    import org.libspark.betweenas3.core.utils.*;
    import org.libspark.betweenas3.events.*;
    import org.libspark.betweenas3.tweens.*;

    public class AbstractTween extends TickerListener implements IITween
    {
        protected var _willTriggerFlags:uint = 0;
        protected var _position:Number = 0;
        protected var _isPlaying:Boolean = false;
        protected var _ticker:ITicker;
        protected var _dispatcher:ClonableEventDispatcher;
        protected var _startTime:Number;
        protected var _classicHandlers:ClassicHandlers;
        protected var _duration:Number = 0;
        protected var _stopOnComplete:Boolean = true;

        public function AbstractTween(param1:ITicker, param2:Number)
        {
            this._ticker = param1;
            this._position = param2;
            return;
        }// end function

        public function get onStop() : Function
        {
            return this._classicHandlers != null ? (this._classicHandlers.onStop) : (null);
        }// end function

        public function set onStop(param1:Function) : void
        {
            this.getClassicHandlers().onStop = param1;
            return;
        }// end function

        public function willTrigger(param1:String) : Boolean
        {
            if (this._dispatcher != null)
            {
                return this._dispatcher.willTrigger(param1);
            }
            return false;
        }// end function

        protected function newInstance() : AbstractTween
        {
            return null;
        }// end function

        public function get onUpdate() : Function
        {
            return this._classicHandlers != null ? (this._classicHandlers.onUpdate) : (null);
        }// end function

        public function get ticker() : ITicker
        {
            return this._ticker;
        }// end function

        public function get duration() : Number
        {
            return this._duration;
        }// end function

        public function gotoAndStop(param1:Number) : void
        {
            if (param1 < 0)
            {
                param1 = 0;
            }
            if (param1 > this._duration)
            {
                param1 = this._duration;
            }
            this._position = param1;
            this.internalUpdate(param1);
            if ((this._willTriggerFlags & 4) != 0)
            {
                this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
            }
            if (this._classicHandlers != null && this._classicHandlers.onUpdate != null)
            {
                this._classicHandlers.onUpdate.apply(null, this._classicHandlers.onUpdateParams);
            }
            this.stop();
            return;
        }// end function

        public function get onPlayParams() : Array
        {
            return this._classicHandlers != null ? (this._classicHandlers.onPlayParams) : (null);
        }// end function

        public function stop() : void
        {
            if (this._isPlaying)
            {
                this._isPlaying = false;
                if ((this._willTriggerFlags & 2) != 0)
                {
                    this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.STOP));
                }
                if (this._classicHandlers != null && this._classicHandlers.onStop != null)
                {
                    this._classicHandlers.onStop.apply(null, this._classicHandlers.onStopParams);
                }
            }
            return;
        }// end function

        public function set onUpdate(param1:Function) : void
        {
            this.getClassicHandlers().onUpdate = param1;
            return;
        }// end function

        public function firePlay() : void
        {
            if ((this._willTriggerFlags & 1) != 0)
            {
                this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.PLAY));
            }
            if (this._classicHandlers != null && this._classicHandlers.onPlay != null)
            {
                this._classicHandlers.onPlay.apply(null, this._classicHandlers.onPlayParams);
            }
            return;
        }// end function

        public function get isPlaying() : Boolean
        {
            return this._isPlaying;
        }// end function

        public function get onUpdateParams() : Array
        {
            return this._classicHandlers != null ? (this._classicHandlers.onUpdateParams) : (null);
        }// end function

        public function get position() : Number
        {
            return this._position;
        }// end function

        public function set onPlayParams(param1:Array) : void
        {
            this.getClassicHandlers().onPlayParams = param1;
            return;
        }// end function

        public function get onPlay() : Function
        {
            return this._classicHandlers != null ? (this._classicHandlers.onPlay) : (null);
        }// end function

        public function set stopOnComplete(param1:Boolean) : void
        {
            this._stopOnComplete = param1;
            return;
        }// end function

        protected function updateWillTriggerFlags() : void
        {
            if (this._dispatcher.willTrigger(TweenEvent.PLAY))
            {
                this._willTriggerFlags = this._willTriggerFlags | 1;
            }
            else
            {
                this._willTriggerFlags = this._willTriggerFlags & ~1;
            }
            if (this._dispatcher.willTrigger(TweenEvent.STOP))
            {
                this._willTriggerFlags = this._willTriggerFlags | 2;
            }
            else
            {
                this._willTriggerFlags = this._willTriggerFlags & ~2;
            }
            if (this._dispatcher.willTrigger(TweenEvent.UPDATE))
            {
                this._willTriggerFlags = this._willTriggerFlags | 4;
            }
            else
            {
                this._willTriggerFlags = this._willTriggerFlags & ~4;
            }
            if (this._dispatcher.willTrigger(TweenEvent.COMPLETE))
            {
                this._willTriggerFlags = this._willTriggerFlags | 8;
            }
            else
            {
                this._willTriggerFlags = this._willTriggerFlags & ~8;
            }
            return;
        }// end function

        public function set onCompleteParams(param1:Array) : void
        {
            this.getClassicHandlers().onCompleteParams = param1;
            return;
        }// end function

        public function dispatchEvent(event:Event) : Boolean
        {
            if (this._dispatcher != null)
            {
                return this._dispatcher.dispatchEvent(event);
            }
            return false;
        }// end function

        public function get onComplete() : Function
        {
            return this._classicHandlers != null ? (this._classicHandlers.onComplete) : (null);
        }// end function

        public function togglePause() : void
        {
            if (this._isPlaying)
            {
                this.stop();
            }
            else
            {
                this.play();
            }
            return;
        }// end function

        public function update(param1:Number) : void
        {
            var _loc_2:Boolean = false;
            if (this._position < this._duration && this._duration <= param1 || this._position > 0 && param1 <= 0)
            {
                _loc_2 = true;
            }
            this._position = param1;
            this.internalUpdate(param1);
            if ((this._willTriggerFlags & 4) != 0)
            {
                this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
            }
            if (this._classicHandlers != null && this._classicHandlers.onUpdate != null)
            {
                this._classicHandlers.onUpdate.apply(null, this._classicHandlers.onUpdateParams);
            }
            if (_loc_2)
            {
                if ((this._willTriggerFlags & 8) != 0)
                {
                    this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.COMPLETE));
                }
                if (this._classicHandlers != null && this._classicHandlers.onComplete != null)
                {
                    this._classicHandlers.onComplete.apply(null, this._classicHandlers.onCompleteParams);
                }
            }
            return;
        }// end function

        public function play() : void
        {
            var _loc_1:Number = NaN;
            if (!this._isPlaying)
            {
                if (this._position >= this._duration)
                {
                    this._position = 0;
                }
                _loc_1 = this._ticker.time;
                this._startTime = _loc_1 - this._position;
                this._isPlaying = true;
                this._ticker.addTickerListener(this);
                if ((this._willTriggerFlags & 1) != 0)
                {
                    this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.PLAY));
                }
                if (this._classicHandlers != null && this._classicHandlers.onPlay != null)
                {
                    this._classicHandlers.onPlay.apply(null, this._classicHandlers.onPlayParams);
                }
                this.tick(_loc_1);
            }
            return;
        }// end function

        public function set onStopParams(param1:Array) : void
        {
            this.getClassicHandlers().onStopParams = param1;
            return;
        }// end function

        public function gotoAndPlay(param1:Number) : void
        {
            var _loc_2:Number = NaN;
            if (param1 < 0)
            {
                param1 = 0;
            }
            if (param1 > this._duration)
            {
                param1 = this._duration;
            }
            this._position = param1;
            if (this._isPlaying)
            {
                if (this._position >= this._duration)
                {
                    this._position = 0;
                }
                _loc_2 = this._ticker.time;
                this._startTime = _loc_2 - this._position;
                this.tick(_loc_2);
            }
            else
            {
                this.play();
            }
            return;
        }// end function

        public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
        {
            if (this._dispatcher != null)
            {
                this._dispatcher.removeEventListener(param1, param2, param3);
                this.updateWillTriggerFlags();
            }
            return;
        }// end function

        public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
        {
            if (this._dispatcher == null)
            {
                this._dispatcher = new ClonableEventDispatcher(this);
            }
            this._dispatcher.addEventListener(param1, param2, param3, param4, param5);
            this.updateWillTriggerFlags();
            return;
        }// end function

        public function fireStop() : void
        {
            if ((this._willTriggerFlags & 2) != 0)
            {
                this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.STOP));
            }
            if (this._classicHandlers != null && this._classicHandlers.onStop != null)
            {
                this._classicHandlers.onStop.apply(null, this._classicHandlers.onStopParams);
            }
            return;
        }// end function

        public function get stopOnComplete() : Boolean
        {
            return this._stopOnComplete;
        }// end function

        public function clone() : ITween
        {
            var _loc_1:* = this.newInstance();
            if (_loc_1 != null)
            {
                _loc_1.copyFrom(this);
            }
            return _loc_1;
        }// end function

        public function get onCompleteParams() : Array
        {
            return this._classicHandlers != null ? (this._classicHandlers.onCompleteParams) : (null);
        }// end function

        public function set onUpdateParams(param1:Array) : void
        {
            this.getClassicHandlers().onUpdateParams = param1;
            return;
        }// end function

        public function get onStopParams() : Array
        {
            return this._classicHandlers != null ? (this._classicHandlers.onStopParams) : (null);
        }// end function

        protected function getClassicHandlers() : ClassicHandlers
        {
            var _loc_1:* = new ClassicHandlers();
            this._classicHandlers = new ClassicHandlers();
            return this._classicHandlers || _loc_1;
        }// end function

        public function set onPlay(param1:Function) : void
        {
            this.getClassicHandlers().onPlay = param1;
            return;
        }// end function

        public function set onComplete(param1:Function) : void
        {
            this.getClassicHandlers().onComplete = param1;
            return;
        }// end function

        override public function tick(param1:Number) : Boolean
        {
            if (!this._isPlaying)
            {
                return true;
            }
            var _loc_2:* = param1 - this._startTime;
            this._position = _loc_2;
            this.internalUpdate(_loc_2);
            if ((this._willTriggerFlags & 4) != 0)
            {
                this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
            }
            if (this._classicHandlers != null && this._classicHandlers.onUpdate != null)
            {
                this._classicHandlers.onUpdate.apply(null, this._classicHandlers.onUpdateParams);
            }
            if (this._isPlaying)
            {
                if (_loc_2 >= this._duration)
                {
                    this._position = this._duration;
                    if (this._stopOnComplete)
                    {
                        this._isPlaying = false;
                        if ((this._willTriggerFlags & 8) != 0)
                        {
                            this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.COMPLETE));
                        }
                        if (this._classicHandlers != null && this._classicHandlers.onComplete != null)
                        {
                            this._classicHandlers.onComplete.apply(null, this._classicHandlers.onCompleteParams);
                        }
                        return true;
                    }
                    else
                    {
                        if ((this._willTriggerFlags & 8) != 0)
                        {
                            this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.COMPLETE));
                        }
                        if (this._classicHandlers != null && this._classicHandlers.onComplete != null)
                        {
                            this._classicHandlers.onComplete.apply(null, this._classicHandlers.onCompleteParams);
                        }
                        this._position = _loc_2 - this._duration;
                        this._startTime = param1 - this._position;
                        this.tick(param1);
                    }
                }
                return false;
            }
            return true;
        }// end function

        public function hasEventListener(param1:String) : Boolean
        {
            if (this._dispatcher != null)
            {
                return this._dispatcher.hasEventListener(param1);
            }
            return false;
        }// end function

        protected function copyFrom(param1:AbstractTween) : void
        {
            this._ticker = param1._ticker;
            this._duration = param1._duration;
            this._stopOnComplete = param1._stopOnComplete;
            if (param1._classicHandlers != null)
            {
                this._classicHandlers = new ClassicHandlers();
                this._classicHandlers.copyFrom(param1._classicHandlers);
            }
            if (param1._dispatcher != null)
            {
                this._dispatcher = new ClonableEventDispatcher(this);
                this._dispatcher.copyFrom(param1._dispatcher);
            }
            this._willTriggerFlags = param1._willTriggerFlags;
            return;
        }// end function

        protected function internalUpdate(param1:Number) : void
        {
            return;
        }// end function

    }
}

class ClassicHandlers extends Object
{
    public var onStop:Function;
    public var onStopParams:Array;
    public var onUpdate:Function;
    public var onUpdateParams:Array;
    public var onPlay:Function;
    public var onComplete:Function;
    public var onPlayParams:Array;
    public var onCompleteParams:Array;

    function ClassicHandlers()
    {
        return;
    }// end function

    public function copyFrom(param1:ClassicHandlers) : void
    {
        this.onPlay = param1.onPlay;
        this.onPlayParams = param1.onPlayParams;
        this.onStop = param1.onStop;
        this.onStopParams = param1.onStopParams;
        this.onUpdate = param1.onUpdate;
        this.onUpdateParams = param1.onUpdateParams;
        this.onComplete = param1.onComplete;
        this.onCompleteParams = param1.onCompleteParams;
        return;
    }// end function

}

