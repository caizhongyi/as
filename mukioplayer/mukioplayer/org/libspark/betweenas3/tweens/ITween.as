package org.libspark.betweenas3.tweens
{

    public interface ITween extends IEventDispatcher
    {

        public function ITween();

        function get onStop() : Function;

        function set onStop(param1:Function) : void;

        function gotoAndPlay(param1:Number) : void;

        function togglePause() : void;

        function set onStopParams(param1:Array) : void;

        function get onUpdate() : Function;

        function set onUpdate(param1:Function) : void;

        function stop() : void;

        function get duration() : Number;

        function gotoAndStop(param1:Number) : void;

        function get onPlayParams() : Array;

        function get stopOnComplete() : Boolean;

        function set onUpdateParams(param1:Array) : void;

        function clone() : ITween;

        function get onCompleteParams() : Array;

        function get isPlaying() : Boolean;

        function set onPlay(param1:Function) : void;

        function get onStopParams() : Array;

        function get position() : Number;

        function get onUpdateParams() : Array;

        function set onComplete(param1:Function) : void;

        function set onPlayParams(param1:Array) : void;

        function get onPlay() : Function;

        function play() : void;

        function get onComplete() : Function;

        function set stopOnComplete(param1:Boolean) : void;

        function set onCompleteParams(param1:Array) : void;

    }
}
