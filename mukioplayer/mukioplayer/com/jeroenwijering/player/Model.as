package com.jeroenwijering.player
{
    import com.jeroenwijering.events.*;
    import com.jeroenwijering.models.*;
    import com.jeroenwijering.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;

    public class Model extends EventDispatcher
    {
        public var config:Object;
        private var item:Object;
        private var thumb:Loader;
        private var image:String;
        private var controller:Controller;
        public var media:Sprite;
        private var models:Object;

        public function Model(param1:Object, param2:MovieClip, param3:SPLoader, param4:Controller) : void
        {
            this.config = param1;
            this.controller = param4;
            this.controller.addEventListener(ControllerEvent.ITEM, this.itemHandler);
            this.controller.addEventListener(ControllerEvent.MUTE, this.muteHandler);
            this.controller.addEventListener(ControllerEvent.PLAY, this.playHandler);
            this.controller.addEventListener(ControllerEvent.PLAYLIST, this.playlistHandler);
            this.controller.addEventListener(ControllerEvent.RESIZE, this.resizeHandler);
            this.controller.addEventListener(ControllerEvent.SEEK, this.seekHandler);
            this.controller.addEventListener(ControllerEvent.STOP, this.stopHandler);
            this.controller.addEventListener(ControllerEvent.VOLUME, this.volumeHandler);
            this.models = new Object();
            this.thumb = new Loader();
            this.thumb.contentLoaderInfo.addEventListener(Event.COMPLETE, this.thumbHandler);
            this.thumb.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.thumbHandler);
            var _loc_5:* = param2.getChildByName("display") as MovieClip;
            this.media = _loc_5.media as Sprite;
            this.media.visible = false;
            Draw.clear(this.media);
            _loc_5.addChildAt(this.thumb, _loc_5.getChildIndex(this.media));
            return;
        }// end function

        private function thumbResize() : void
        {
            Stretcher.stretch(this.thumb, this.config["width"], this.config["height"], this.config["stretching"]);
            return;
        }// end function

        public function addModel(param1:AbstractModel, param2:String) : void
        {
            this.models[param2] = param1;
            return;
        }// end function

        private function volumeHandler(event:ControllerEvent) : void
        {
            if (this.item)
            {
                this.models[this.item["type"]].volume(event.data.percentage);
            }
            return;
        }// end function

        private function playlistHandler(event:ControllerEvent) : void
        {
            var _loc_2:* = this.controller.playlist[this.config["item"]]["image"];
            if (_loc_2 && _loc_2 != this.image)
            {
                this.image = _loc_2;
                this.thumb.load(new URLRequest(_loc_2), new LoaderContext(true));
            }
            return;
        }// end function

        private function audioOnly() : Boolean
        {
            var _loc_1:* = this.item["file"].substr(-3);
            if (_loc_1 == "m4a" || _loc_1 == "mp3" || _loc_1 == "aac")
            {
                return true;
            }
            return false;
        }// end function

        private function thumbHandler(event:Event) : void
        {
            var evt:* = event;
            try
            {
                Bitmap(this.thumb.content).smoothing = true;
            }
            catch (err:Error)
            {
            }
            this.thumbResize();
            return;
        }// end function

        private function stopHandler(event:ControllerEvent = ) : void
        {
            if (this.item)
            {
                this.models[this.item["type"]].stop();
            }
            return;
        }// end function

        private function muteHandler(event:ControllerEvent) : void
        {
            if (this.item)
            {
                if (event.data.state == true)
                {
                    this.models[this.item["type"]].volume(0);
                }
                else
                {
                    this.models[this.item["type"]].volume(this.config["volume"]);
                }
            }
            return;
        }// end function

        private function seekHandler(event:ControllerEvent) : void
        {
            if (this.item)
            {
                this.models[this.item["type"]].seek(event.data.position);
            }
            return;
        }// end function

        private function playHandler(event:ControllerEvent) : void
        {
            if (this.item)
            {
                if (event.data.state == true)
                {
                    this.models[this.item["type"]].play();
                }
                else
                {
                    this.models[this.item["type"]].pause();
                }
            }
            return;
        }// end function

        private function itemHandler(event:ControllerEvent) : void
        {
            if (this.item)
            {
                this.models[this.item["type"]].stop();
                this.media.removeChild(this.models[this.item["type"]]);
            }
            this.item = this.controller.playlist[this.config["item"]];
            if (this.models[this.item["type"]])
            {
                this.media.addChild(this.models[this.item["type"]]);
                this.models[this.item["type"]].load(this.item);
            }
            else
            {
                this.sendEvent(ModelEvent.ERROR, {message:"No suiteable model found for playback of this file."});
            }
            if (this.item["image"])
            {
                if (this.item["image"] != this.image)
                {
                    this.image = this.item["image"];
                    this.thumb.load(new URLRequest(this.item["image"]), new LoaderContext(true));
                }
            }
            else if (this.image)
            {
                this.image = undefined;
                this.thumb.unload();
            }
            return;
        }// end function

        public function sendEvent(param1:String, param2:Object) : void
        {
            if (param1 == ModelEvent.STATE)
            {
                if (param2.newstate == this.config["state"])
                {
                    return;
                }
                param2["oldstate"] = this.config["state"];
                this.config["state"] = param2.newstate;
                switch(param2["newstate"])
                {
                    case ModelStates.IDLE:
                    {
                        this.sendEvent(ModelEvent.LOADED, {loaded:0, offset:0, total:0});
                    }
                    case ModelStates.COMPLETED:
                    {
                        this.thumb.visible = true;
                        this.media.visible = false;
                        this.sendEvent(ModelEvent.TIME, {position:this.item["start"], duration:this.item["duration"]});
                        break;
                    }
                    case ModelStates.BUFFERING:
                    case ModelStates.PLAYING:
                    {
                        this.thumb.visible = this.audioOnly();
                        this.media.visible = !this.audioOnly();
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            Logger.log(param2, param1);
            dispatchEvent(new ModelEvent(param1, param2));
            return;
        }// end function

        private function resizeHandler(event:ControllerEvent) : void
        {
            if (this.thumb.width)
            {
                this.thumbResize();
            }
            if (this.item)
            {
                this.models[this.item["type"]].resize();
            }
            return;
        }// end function

    }
}
