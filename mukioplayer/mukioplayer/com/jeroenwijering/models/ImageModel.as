package com.jeroenwijering.models
{
    import com.jeroenwijering.events.*;
    import com.jeroenwijering.player.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class ImageModel extends AbstractModel
    {
        private var interval:Number;
        private var loader:Loader;

        public function ImageModel(param1:Model) : void
        {
            super(param1);
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loaderHandler);
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
            addChild(this.loader);
            return;
        }// end function

        private function errorHandler(event:ErrorEvent) : void
        {
            this.stop();
            model.sendEvent(ModelEvent.ERROR, {message:event.text});
            return;
        }// end function

        override public function stop() : void
        {
            clearInterval(this.interval);
            try
            {
                this.loader.close();
            }
            catch (err:Error)
            {
                loader.unload();
            }
            position = 0;
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.IDLE});
            return;
        }// end function

        override public function load(param1:Object) : void
        {
            item = param1;
            position = 0;
            this.loader.load(new URLRequest(item["file"]), new LoaderContext(true));
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.BUFFERING});
            return;
        }// end function

        protected function positionInterval() : void
        {
            position = Math.round(position * 10 + 1) / 10;
            if (position < item["duration"])
            {
                model.sendEvent(ModelEvent.TIME, {position:position, duration:item["duration"]});
            }
            else if (item["duration"] > 0)
            {
                clearInterval(this.interval);
                model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.COMPLETED});
            }
            return;
        }// end function

        override public function play() : void
        {
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PLAYING});
            this.interval = setInterval(this.positionInterval, 100);
            return;
        }// end function

        override public function pause() : void
        {
            clearInterval(this.interval);
            model.sendEvent(ModelEvent.STATE, {newstate:ModelStates.PAUSED});
            return;
        }// end function

        private function loaderHandler(event:Event) : void
        {
            var evt:* = event;
            try
            {
                Bitmap(this.loader.content).smoothing = true;
            }
            catch (err:Error)
            {
            }
            model.sendEvent(ModelEvent.META, {height:evt.target.height, width:evt.target.width});
            resize();
            this.play();
            return;
        }// end function

        override public function seek(param1:Number) : void
        {
            clearInterval(this.interval);
            position = param1;
            this.play();
            return;
        }// end function

    }
}
