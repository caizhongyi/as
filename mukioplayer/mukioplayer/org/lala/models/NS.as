package org.lala.models
{
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class NS extends EventDispatcher
    {
        private var _$id:uint;
        private var _$stopSign:Boolean;
        private var _$volume:Number = 0.7;
        private var _$btimer:Timer;
        private var _$bufferTime:uint;
        private var _$isLoad:Boolean = false;
        private var _$nc:NetConnection;
        private var _$ns:NetStream;
        private var _$is_hc:Boolean;
        private var _$isStop:Boolean;
        private var _$ptimer:Timer;

        public function NS(param1:uint = 5) : void
        {
            this._$btimer = new Timer(1000);
            this._$ptimer = new Timer(100);
            this._$bufferTime = param1;
            this.init();
            return;
        }// end function

        public function get loaded() : Number
        {
            return this._$ns.bytesLoaded;
        }// end function

        private function ncStatus(event:NetStatusEvent) : void
        {
            if (event.info.code == "NetConnection.Connect.Success")
            {
                this.createNS();
            }
            return;
        }// end function

        public function stopV() : void
        {
            this._$ptimer.stop();
            this._$btimer.stop();
            this._$ns.pause();
            this._$ns.seek(0);
            return;
        }// end function

        private function init() : void
        {
            this.addEventListener(NSEvent.CHECK_FULL, this.onReallyFull);
            this._$btimer.addEventListener(TimerEvent.TIMER, this.checkBuff);
            this._$ptimer.addEventListener(TimerEvent.TIMER, this.onPlaying);
            this._$nc = new NetConnection();
            this._$nc.addEventListener(NetStatusEvent.NET_STATUS, this.ncStatus);
            this._$nc.connect(null);
            return;
        }// end function

        public function onReallyFull(event:NSEvent) : void
        {
            this._$btimer.stop();
            return;
        }// end function

        public function get id() : uint
        {
            return this._$id;
        }// end function

        private function setVolume(param1:Number = 0.7) : void
        {
            this._$volume = param1;
            var _loc_2:* = new SoundTransform(this._$volume, 0);
            this._$ns.soundTransform = _loc_2;
            return;
        }// end function

        public function pauseV() : void
        {
            this._$ptimer.stop();
            this._$ns.pause();
            return;
        }// end function

        public function get volume() : Number
        {
            return this._$volume;
        }// end function

        public function playV() : void
        {
            this._$ptimer.start();
            if (!this._$isLoad)
            {
                this._$btimer.start();
            }
            this._$isStop = false;
            this._$ns.resume();
            return;
        }// end function

        public function onCuePoint(param1:Object) : void
        {
            trace("cue point" + param1);
            return;
        }// end function

        public function get bufferTime() : int
        {
            return this._$bufferTime;
        }// end function

        private function asyncHandler(event:AsyncErrorEvent) : void
        {
            trace("AsyncErrorEvent::" + event.type);
            return;
        }// end function

        public function loadV(param1:String) : void
        {
            var param1:* = param1;
            var path:* = param1;
            this._$isStop = false;
            this._$is_hc = false;
            this._$stopSign = false;
            try
            {
                this._$ns.play(path);
            }
            catch (e:Error)
            {
                trace(e);
            }
            this._$ns.pause();
            this._$btimer.start();
            return;
        }// end function

        public function set volume(param1:Number) : void
        {
            param1 = param1 > 1 ? (1) : (param1);
            param1 = param1 < 0 ? (0) : (param1);
            this.setVolume(param1);
            return;
        }// end function

        public function set id(param1:uint) : void
        {
            this._$id = param1;
            return;
        }// end function

        private function createNS() : void
        {
            this._$ns = new NetStream(this._$nc);
            this._$ns.bufferTime = this._$bufferTime;
            this._$ns.client = this;
            this.setVolume();
            this.removeEvent(this._$ns);
            this.addEvent(this._$ns);
            return;
        }// end function

        public function get total() : Number
        {
            return this._$ns.bytesTotal;
        }// end function

        public function get ns() : NetStream
        {
            return this._$ns;
        }// end function

        public function get time() : Number
        {
            var _loc_1:* = Math.round(this._$ns.time * 1000);
            return _loc_1;
        }// end function

        public function onMetaData(param1:Object) : void
        {
            dispatchEvent(new NSEvent(NSEvent.META_DATA, param1));
            return;
        }// end function

        private function onPlaying(event:TimerEvent) : void
        {
            dispatchEvent(new NSEvent(NSEvent.PLAYING, this.time));
            return;
        }// end function

        public function set bufferTime(param1:int) : void
        {
            this._$bufferTime = param1;
            this._$ns.bufferTime = param1;
            return;
        }// end function

        public function closeV() : void
        {
            this._$ptimer.stop();
            this._$btimer.stop();
            this._$ns.pause();
            this._$ns.close();
            return;
        }// end function

        public function seekV(param1:Number) : void
        {
            param1 = Math.floor(param1 / 1000);
            this._$ns.seek(param1);
            return;
        }// end function

        public function onLastSecond(param1:Object) : void
        {
            trace("last second" + param1);
            return;
        }// end function

        private function removeEvent(param1:NetStream) : void
        {
            param1.removeEventListener(NetStatusEvent.NET_STATUS, this.statusHandler);
            param1.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncHandler);
            return;
        }// end function

        private function statusHandler(event:NetStatusEvent) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:* = event.info.code;
            switch(_loc_3)
            {
                case "NetStream.Play.Start":
                {
                    dispatchEvent(new NSEvent(NSEvent.READY));
                    break;
                }
                case "NetStream.Play.Stop":
                {
                    if (!this._$isStop)
                    {
                        this._$isStop = true;
                        trace("stopStop");
                        dispatchEvent(new NSEvent(NSEvent.STOP));
                    }
                    break;
                }
                case "NetStream.Buffer.Empty":
                {
                    if (this._$stopSign)
                    {
                        if (!this._$isStop)
                        {
                            this._$isStop = true;
                            trace("emptyStop");
                            dispatchEvent(new NSEvent(NSEvent.STOP));
                        }
                    }
                    else
                    {
                        _loc_2 = Math.round(this._$ns.bufferLength / this._$ns.bufferTime * 100) / 100;
                        dispatchEvent(new NSEvent(NSEvent.EMPTY, _loc_2));
                    }
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    if (!this._$is_hc)
                    {
                        this._$is_hc = true;
                        dispatchEvent(new NSEvent(NSEvent.PLAY));
                    }
                    else
                    {
                        dispatchEvent(new NSEvent(NSEvent.FULL));
                    }
                    break;
                }
                case "NetStream.Buffer.Flush":
                {
                    if (!this._$stopSign)
                    {
                        this._$stopSign = true;
                    }
                    dispatchEvent(new NSEvent(NSEvent.FLUSH));
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                {
                    trace("StreamNotFound");
                    dispatchEvent(new NSEvent(NSEvent.FILE_EMPTY));
                    break;
                }
                case "NetStream.Seek.Notify":
                {
                    this._$stopSign = false;
                    break;
                }
                case "NetStream.Seek.Failed":
                {
                    break;
                }
                case "NetStream.Seek.InvalidTime":
                {
                    dispatchEvent(new NSEvent(NSEvent.SEEK_ERROR));
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            return;
        }// end function

        private function addEvent(param1:NetStream) : void
        {
            param1.addEventListener(NetStatusEvent.NET_STATUS, this.statusHandler);
            param1.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncHandler);
            return;
        }// end function

        private function checkBuff(event:TimerEvent) : void
        {
            dispatchEvent(new NSEvent(NSEvent.BUFFERING, this.loadPercent));
            if (this.loadPercent == 1)
            {
                trace("really full!");
                dispatchEvent(new NSEvent(NSEvent.CHECK_FULL));
                this.removeEventListener(TimerEvent.TIMER, this.checkBuff);
                this._$btimer.stop();
                this._$isLoad = true;
            }
            return;
        }// end function

        public function get loadPercent() : Number
        {
            return this._$ns.bytesLoaded / this._$ns.bytesTotal;
        }// end function

    }
}
