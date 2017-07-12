package com.jeroenwijering.models
{
    import com.jeroenwijering.events.*;
    import com.jeroenwijering.player.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class SoundModel extends AbstractModel
    {
        private var channel:SoundChannel;
        protected var interval:Number;
        private var sound:Sound;
        private var loadinterval:Number;
        private var context:SoundLoaderContext;
        private var transformer:SoundTransform;

        public function SoundModel(param1:Model) : void
        {
            super(param1);
            this.transformer = new SoundTransform();
            this.context = new SoundLoaderContext(model.config["bufferlength"] * 1000, true);
            return;
        }// end function

        private function id3Handler(event:Event) : void
        {
            var id3:ID3Info;
            var obj:Object;
            var evt:* = event;
            try
            {
                id3 = this.sound.id3;
                obj;
                model.sendEvent(ModelEvent.META, obj);
            }
            catch (err:Error)
            {
            }
            return;
        }// end function

        private function errorHandler(event:ErrorEvent) : void
        {
            this.stop();
            model.sendEvent(ModelEvent.ERROR, {message:event.text});
            return;
        }// end function

        private function loadHandler() : void
        {
            var _loc_1:* = this.sound.bytesLoaded;
            var _loc_2:* = this.sound.bytesTotal;
            model.sendEvent(ModelEvent.LOADED, {loaded:_loc_1, total:_loc_2});
            if (_loc_1 / _loc_2 > 0.1 && item["duration"] == 0)
            {
                item["duration"] = this.sound.length / 1000 / _loc_1 * _loc_2;
            }
            if (_loc_1 == _loc_2 && _loc_1 > 0)
            {
                clearInterval(this.loadinterval);
            }
            return;
        }// end function

        override public function stop() : void
        {
            clearInterval(this.loadinterval);
            clearInterval(this.interval);
            if (this.channel)
            {
                this.channel.stop();
            }
            try
            {
                this.sound.close();
            }
            catch (err:Error)
            {
            }
            position = 0;
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.IDLE});
            return;
        }// end function

        protected function positionInterval() : void
        {
            position = Math.round(this.channel.position / 100) / 10;
            if (model.config["state"] != ModelStates.PLAYING && this.channel.position > 0)
            {
                model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PLAYING});
            }
            if (position < item["duration"])
            {
                model.sendEvent(ModelEvent.TIME, {position:position, duration:item["duration"]});
            }
            else if (item["duration"] > 0)
            {
                this.pause();
                model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.COMPLETED});
            }
            return;
        }// end function

        private function completeHandler(event:Event) : void
        {
            clearInterval(this.interval);
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.COMPLETED});
            return;
        }// end function

        override public function play() : void
        {
            this.channel = this.sound.play(position * 1000, 0, this.transformer);
            this.channel.addEventListener(Event.SOUND_COMPLETE, this.completeHandler);
            this.interval = setInterval(this.positionInterval, 100);
            return;
        }// end function

        override public function load(param1:Object) : void
        {
            item = param1;
            position = 0;
            this.sound = new Sound();
            this.sound.addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
            this.sound.addEventListener(Event.ID3, this.id3Handler);
            this.sound.load(new URLRequest(item["file"]), this.context);
            this.play();
            if (item["start"] > 0)
            {
                this.seek(item["start"]);
            }
            this.loadinterval = setInterval(this.loadHandler, 200);
            if (model.config["mute"] == true)
            {
                this.volume(0);
            }
            else
            {
                this.volume(model.config["volume"]);
            }
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.BUFFERING});
            return;
        }// end function

        override public function seek(param1:Number) : void
        {
            position = param1;
            clearInterval(this.interval);
            this.channel.stop();
            this.play();
            return;
        }// end function

        override public function volume(param1:Number) : void
        {
            this.transformer.volume = param1 / 100;
            if (this.channel)
            {
                this.channel.soundTransform = this.transformer;
            }
            return;
        }// end function

        override public function pause() : void
        {
            this.channel.stop();
            clearInterval(this.interval);
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PAUSED});
            return;
        }// end function

    }
}
