package com.jeroenwijering.models
{
    import com.jeroenwijering.events.*;
    import com.jeroenwijering.player.*;
    import com.jeroenwijering.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;

    public class LivestreamModel extends AbstractModel
    {
        private var player:Object;
        private var wrapper:Object;
        private var playing:Boolean;
        private const LOCATION:String = "http://cdn.livestream.com/chromelessPlayer/wrappers/SimpleWrapper.swf";
        private var loader:Loader;

        public function LivestreamModel(param1:Model) : void
        {
            super(param1);
            mouseEnabled = true;
            Security.allowDomain("*");
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loaderHandler);
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
            addChild(this.loader);
            return;
        }// end function

        private function playerErrorHandler(event:Event) : void
        {
            this.stop();
            model.sendEvent(ModelEvent.ERROR, {message:Object(event).message});
            return;
        }// end function

        override public function stop() : void
        {
            if (this.playing)
            {
                this.player.stop();
                this.playing = false;
            }
            position = item["start"];
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.IDLE});
            return;
        }// end function

        private function playerReadyHandler(event:Event) : void
        {
            this.player = this.wrapper.getPlayer();
            this.player.addEventListener("errorEvent", this.playerErrorHandler);
            this.player.devKey = model.config["livestream.devkey"];
            this.player.showMuteButton = false;
            this.player.showPauseButton = false;
            this.player.showPlayButton = false;
            this.player.showSpinner = false;
            this.player.volumeOverlayEnabled = true;
            if (model.config["mute"] == true)
            {
                this.volume(0);
            }
            else
            {
                this.volume(model.config["volume"]);
            }
            this.resize();
            this.play();
            return;
        }// end function

        private function applicationHandler(event:Event) : void
        {
            this.wrapper = Object(this.loader.content).application;
            this.wrapper.addEventListener("ready", this.playerReadyHandler);
            return;
        }// end function

        private function errorHandler(event:ErrorEvent) : void
        {
            this.stop();
            model.sendEvent(ModelEvent.ERROR, {message:event.text});
            return;
        }// end function

        override public function volume(param1:Number) : void
        {
            if (this.player)
            {
                this.player.volume = param1 / 100;
            }
            return;
        }// end function

        override public function play() : void
        {
            this.player.channel = item["file"];
            this.player.play();
            this.playing = true;
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PLAYING});
            return;
        }// end function

        override public function pause() : void
        {
            this.stop();
            return;
        }// end function

        private function loaderHandler(event:Event) : void
        {
            this.loader.content.addEventListener("applicationComplete", this.applicationHandler);
            return;
        }// end function

        override public function resize() : void
        {
            if (this.wrapper)
            {
                Stretcher.stretch(DisplayObject(this.wrapper), model.config["width"], model.config["height"], Stretcher.EXACTFIT);
            }
            return;
        }// end function

        override public function load(param1:Object) : void
        {
            var itm:* = param1;
            item = itm;
            position = item["start"];
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.BUFFERING});
            if (this.player)
            {
                this.play();
            }
            else
            {
                Security.loadPolicyFile("http://cdn.livestream.com/crossdomain.xml");
                try
                {
                    this.loader.load(new URLRequest(this.LOCATION), new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain));
                }
                catch (e:SecurityError)
                {
                    loader.load(new URLRequest(LOCATION));
                }
            }
            return;
        }// end function

    }
}
