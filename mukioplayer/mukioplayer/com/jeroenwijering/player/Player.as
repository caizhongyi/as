package com.jeroenwijering.player
{
    import com.jeroenwijering.events.*;
    import com.jeroenwijering.models.*;
    import com.jeroenwijering.plugins.*;
    import com.jeroenwijering.utils.*;
    import flash.display.*;
    import flash.events.*;
    import mx.core.*;
    import org.lala.models.*;
    import org.lala.plugins.*;
    import org.lala.utils.*;

    public class Player extends MovieClip
    {
        public var config:Object;
        private const EmbeddedSkin:Class;
        protected var getter:CommentGetter;
        protected var configger:Configger;
        protected var loaderAnim:MovieClip;
        private var reference:MovieClip;
        protected var controller:Controller;
        protected var mcl:MovieClipLoaderAsset;
        protected var loaderScreen:Sprite;
        public var view:View;
        protected var model:Model;
        protected var commentView:CommentView;
        protected var sploader:SPLoader;
        protected var commentUI:CommentListSender;
        public var skin:MovieClip;
        public static var WIDTH:int = 540;
        public static var HEIGHT:int = 384;

        public function Player() : void
        {
            this.EmbeddedSkin = Player_EmbeddedSkin;
            this.config = {author:undefined, date:undefined, description:undefined, duration:0, file:undefined, cfile:undefined, vid:"-1", cid:undefined, nico:undefined, image:undefined, link:undefined, start:0, streamer:undefined, tags:undefined, title:undefined, type:undefined, backcolor:undefined, frontcolor:undefined, lightcolor:undefined, screencolor:undefined, controlbar:"bottom", dock:false, height:300, icons:true, playlist:"none", playlistsize:180, skin:undefined, width:400, autostart:false, bandwidth:5000, bufferlength:1, displayclick:"play", fullscreen:true, item:0, level:0, linktarget:"_blank", logo:undefined, mute:false, repeat:"none", shuffle:false, smoothing:true, state:"IDLE", stretching:"uniform", volume:90, abouttext:"MukioPlayer1.150 Web", aboutlink:"http://code.google.com/p/mukioplayer/", client:undefined, debug:"none", id:undefined, plugins:undefined, version:"1.150"};
            addEventListener(Event.ADDED_TO_STAGE, function (event:Event) : void
            {
                _Player();
                return;
            }// end function
            );
            return;
        }// end function

        protected function loadSkin(event:Event) : void
        {
            if (this.config["tracecall"])
            {
                Logger.output = this.config["tracecall"];
            }
            else
            {
                Logger.output = this.config["debug"];
            }
            this.sploader = new SPLoader(this);
            this.sploader.addEventListener(SPLoaderEvent.SKIN, this.loadMVC);
            this.sploader.loadSkin();
            return;
        }// end function

        protected function loadMVC(event:SPLoaderEvent) : void
        {
            this.controller = new Controller(this.config, this.skin, this.sploader);
            this.model = new Model(this.config, this.skin, this.sploader, this.controller);
            this.view = new View(this.config, this.skin, this.sploader, this.controller, this.model);
            this.controller.closeMVC(this.model, this.view);
            this.addModels();
            this.addPlugins();
            this.sploader.addEventListener(SPLoaderEvent.PLUGINS, this.startPlayer);
            this.sploader.loadPlugins();
            return;
        }// end function

        protected function loadConfig(event:Event = null) : void
        {
            this.skin = MovieClip(LoaderInfo(event.target).content).player;
            this.skin.visible = false;
            addChild(this.skin);
            this.configger = new Configger(this.reference);
            this.configger.addEventListener(Event.COMPLETE, this.loadSkin);
            this.configger.load(this.config);
            return;
        }// end function

        protected function startPlayer(event:SPLoaderEvent) : void
        {
            this.view.sendEvent(ViewEvent.REDRAW);
            this.skin.visible = true;
            removeChild(this.loaderScreen);
            dispatchEvent(new PlayerEvent(PlayerEvent.READY));
            this.config["file"] = this.config["vid"] ? ("sina") : (this.config["file"]);
            this.view.playerReady();
            if (this.config["file"])
            {
                this.view.sendEvent(ViewEvent.LOAD, this.config);
            }
            return;
        }// end function

        public function _Player(param1:MovieClip = null) : void
        {
            this.reference = this;
            if (param1 != null)
            {
                this.reference = param1;
                param1.addChild(this);
            }
            this.loaderScreen = new Sprite();
            this.loaderScreen.name = "loaderScreen";
            this.loaderScreen.graphics.clear();
            this.loaderScreen.graphics.beginFill(0, 1);
            this.loaderScreen.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
            this.loaderScreen.graphics.endFill();
            addChild(this.loaderScreen);
            this.resizeStage();
            return;
        }// end function

        protected function resizeStage(event:Event = null) : void
        {
            this.loaderAnim = new Loading();
            this.loaderScreen.addChild(this.loaderAnim);
            this.loaderAnim.x = stage.stageWidth / 2;
            this.loaderAnim.y = stage.stageHeight / 2;
            this.mcl = new this.EmbeddedSkin() as MovieClipLoaderAsset;
            var _loc_2:* = Loader(this.mcl.getChildAt(0));
            _loc_2.contentLoaderInfo.addEventListener(Event.INIT, this.loadConfig);
            return;
        }// end function

        protected function addModels() : void
        {
            this.model.addModel(new HTTPModel(this.model), "http");
            this.model.addModel(new ImageModel(this.model), "image");
            this.model.addModel(new LivestreamModel(this.model), "livestream");
            this.model.addModel(new RTMPModel(this.model), "rtmp");
            this.model.addModel(new SoundModel(this.model), "sound");
            this.model.addModel(new VideoModel(this.model), "video");
            this.model.addModel(new YoutubeModel(this.model), "youtube");
            this.model.addModel(new SINAModel(this.model), "sina");
            this.model.addModel(new BOKECCModel(this.model), "bokecc");
            this.model.addModel(new YOUKUModel(this.model), "youku");
            this.model.addModel(new SIXROOMModel(this.model), "6room");
            this.model.addModel(new QQModel(this.model), "qq");
            return;
        }// end function

        protected function addPlugins() : void
        {
            var _loc_1:Array = null;
            this.sploader.addPlugin(new Display(), "display");
            this.sploader.addPlugin(new Rightclick(), "rightclick");
            this.sploader.addPlugin(new Controlbar(), "controlbar");
            this.sploader.addPlugin(new Playlist(), "playlist");
            this.sploader.addPlugin(new Dock(), "dock");
            this.sploader.addPlugin(new Watermark(false), "watermark");
            if (this.config["pid"])
            {
                this.config["cfile"] = "http://www.avfun001.org/subtitle/" + this.config["pid"];
            }
            if (this.config["avid"])
            {
                _loc_1 = String(this.config["avid"]).split("levelup");
                this.config["file"] = "http://pl.bilibili.us/uploads/" + _loc_1[0] + "/" + _loc_1[1] + ".flv";
                this.config["cid"] = this.config["avid"];
                this.config["vid"] = undefined;
            }
            if ((this.config["id"] || this.config["vid"]) && !this.config["file"] && this.config["type"] == "video")
            {
                this.config["type"] = "sina";
            }
            if ((this.config["id"] || this.config["vid"] || this.config["pid"]) && this.config["file"])
            {
                if (!String(this.config["file"]).match(".mp3"))
                {
                    this.config["type"] = "video";
                }
            }
            if (this.config["type2"] == "qq")
            {
                this.config["type"] = "qq";
            }
            if (this.config["id"] && !this.config["file"])
            {
                this.config["vid"] = this.config["id"];
            }
            else if (this.config["id"])
            {
                this.config["cid"] = this.config["id"];
                this.config["vid"] = "-1";
            }
            this.config["id"] = undefined;
            if (this.config["vid"] == "-1" && this.config["file"] != undefined)
            {
                this.config["vid"] = undefined;
            }
            this.getter = new CommentGetter();
            this.commentUI = new CommentListSender(this.getter);
            this.commentView = new CommentView(this.getter, this.commentUI);
            this.sploader.addPlugin(this.commentUI, "commentlistsender");
            this.sploader.addPlugin(this.commentView, "commentview");
            return;
        }// end function

    }
}
