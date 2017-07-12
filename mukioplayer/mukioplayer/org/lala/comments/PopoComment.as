package org.lala.comments
{
    import com.jeroenwijering.player.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.text.*;
    import flash.utils.*;
    import org.libspark.betweenas3.*;
    import org.libspark.betweenas3.easing.*;
    import org.libspark.betweenas3.events.*;
    import org.libspark.betweenas3.tweens.*;

    public class PopoComment extends Sprite
    {
        private var bg:MovieClip;
        private var twi:ITween;
        private var H:int;
        private var tmd:Timer;
        private var two:ITween;
        public var completeHandler:Function;
        private var W:int;
        private var item:Object;
        private var ttf:TextField;
        private var h:int;
        private var tmte:Timer;
        private var tf:TextFormat;
        private var w:int;
        public static var TIMER_TICK:Number = 1;
        public static var RADIUS:Number = Player.WIDTH / 2;
        public static var screenW:int = Player.WIDTH;
        public static var screenH:int = Player.HEIGHT;
        public static var TIMER_INTERVAL:Number = 8;

        public function PopoComment(param1:Object)
        {
            var _loc_2:String = null;
            this.item = {};
            for (_loc_2 in param1)
            {
                
                this.item[_loc_2] = param1[_loc_2];
            }
            visible = false;
            this.init();
            return;
        }// end function

        private function getRndStyle() : String
        {
            var _loc_1:Array = ["right", "left", "rise", "drop", "fade", "fade"];
            return _loc_1[Math.floor(Math.random() * 5)];
        }// end function

        private function getXPosition(param1:String, param2:Boolean = true) : Number
        {
            var _loc_3:* = parseInt(param1);
            if (_loc_3 > 0 && _loc_3 <= 360)
            {
                return this.item.x + PopoComment.RADIUS * Math.cos((-_loc_3) / 180 * Math.PI);
            }
            switch(param1)
            {
                case "left":
                {
                }
                case "right":
                {
                }
                case "drop":
                case "rise":
                {
                }
                default:
                {
                    break;
                }
            }
            switch(param1)
            {
                case "left":
                {
                }
                case "right":
                {
                }
                case "drop":
                case "rise":
                {
                }
                default:
                {
                    break;
                }
            }
            return 0;
        }// end function

        private function getPosition(param1:String, param2:String) : void
        {
            this.item.stx = this.getXPosition(param1);
            this.item.sty = this.getYPosition(param1);
            this.item.edx = this.getXPosition(param2, false);
            this.item.edy = this.getYPosition(param2, false);
            return;
        }// end function

        public function start() : void
        {
            visible = true;
            if (this.item.inStyle == "normal")
            {
                this.tmd.start();
            }
            else
            {
                this.twi.play();
            }
            if (this.item.tEffect == "lupin")
            {
                this.tmte.start();
            }
            return;
        }// end function

        private function setPosition() : void
        {
            if (!this.item.x)
            {
                this.item.x = 0;
            }
            if (!this.item.y)
            {
                this.item.y = 0;
            }
            if (!this.item.style)
            {
                this.item.style = "normal";
            }
            if (this.W > PopoComment.screenW)
            {
                this.w = this.w - (this.W - PopoComment.screenW);
                this.W = this.w;
                this.h = this.tf.size as Number;
                this.H = this.h + 30;
            }
            var _loc_1:* = this.item.x;
            var _loc_2:* = this.item.y - this.H;
            if (_loc_1 + this.W <= screenW)
            {
                if (_loc_2 > 0)
                {
                    this.bg.gotoAndStop("LB");
                }
                else
                {
                    _loc_2 = _loc_2 + this.H;
                    this.bg.gotoAndStop("LT");
                }
            }
            else if (_loc_2 >= 0)
            {
                _loc_1 = _loc_1 - this.W;
                this.bg.gotoAndStop("RB");
            }
            else
            {
                _loc_1 = _loc_1 - this.W;
                _loc_2 = _loc_2 + this.H;
                this.bg.gotoAndStop("RT");
            }
            if (_loc_1 < 0)
            {
                _loc_1 = 0;
            }
            if (_loc_2 < 0)
            {
                _loc_2 = 0;
            }
            this.item.x = _loc_1;
            this.item.y = _loc_2;
            return;
        }// end function

        private function getYPosition(param1:String, param2:Boolean = true) : Number
        {
            var _loc_3:* = parseInt(param1);
            if (_loc_3 > 0 && _loc_3 <= 360)
            {
                return this.item.y + PopoComment.RADIUS * Math.sin((-_loc_3) / 180 * Math.PI);
            }
            switch(param1)
            {
                case "drop":
                {
                }
                case "rise":
                {
                }
                case "left":
                case "right":
                {
                }
                default:
                {
                    break;
                }
            }
            switch(param1)
            {
                case "drop":
                {
                }
                case "rise":
                {
                }
                case "left":
                case "right":
                {
                }
                default:
                {
                    break;
                }
            }
            return 0;
        }// end function

        private function getTextFormat() : TextFormat
        {
            var _loc_1:* = new TextFormat();
            _loc_1.size = this.item.size;
            _loc_1.color = this.item.color;
            var _loc_2:* = this.item.tStyle;
            if (_loc_2.match("italic"))
            {
                _loc_1.italic = true;
            }
            if (_loc_2.match("bold"))
            {
                _loc_1.bold = true;
            }
            if (_loc_2.match("underline"))
            {
                _loc_1.underline = true;
            }
            return _loc_1;
        }// end function

        private function init() : void
        {
            var outStyle:String;
            var self:PopoComment;
            var num:int;
            var tEffectHandler:Function;
            y = this.item.y;
            this.tf = this.getTextFormat();
            this.ttf = new TextField();
            this.ttf.autoSize = "left";
            this.ttf.defaultTextFormat = this.tf;
            var _loc_2:int = 15;
            this.ttf.y = 15;
            this.ttf.x = _loc_2;
            this.ttf.text = this.item.text;
            this.w = this.ttf.width;
            this.h = this.ttf.height;
            this.W = this.w + 30;
            this.H = this.h + 30;
            this.bg = FukidashiFactory.getFukidashi(this.item.style);
            this.bg.alpha = this.item.alpha / 100;
            var _loc_2:int = 0;
            this.bg.y = 0;
            this.bg.x = _loc_2;
            this.bg.width = this.W;
            this.bg.height = this.H;
            this.bg.filters = [new DropShadowFilter(10, 45, 0, 0.5)];
            addChild(this.bg);
            addChild(this.ttf);
            this.setPosition();
            var inStyle:* = this.item.inStyle == "random" ? (this.getRndStyle()) : (this.item.inStyle);
            outStyle = this.item.outStyle == "random" ? (this.getRndStyle()) : (this.item.outStyle);
            this.getPosition(inStyle, outStyle);
            self;
            if (inStyle == "fade")
            {
                x = this.item.x;
                y = this.item.y;
                alpha = 0;
                this.twi = BetweenAS3.tween(this, {alpha:1}, {alpha:0}, 0.5, Linear.easeOut);
                this.twi.addEventListener(TweenEvent.COMPLETE, function (event:TweenEvent) : void
            {
                twi = null;
                self.tmd.start();
                return;
            }// end function
            );
            }
            else if (inStyle == "normal")
            {
                x = this.item.x;
                y = this.item.y;
            }
            else
            {
                x = this.item.stx;
                y = this.item.sty;
                this.twi = BetweenAS3.tween(this, {x:this.item.x, y:this.item.y}, {x:this.item.stx, y:this.item.sty}, 1, Expo.easeOut);
                this.twi.addEventListener(TweenEvent.COMPLETE, function (event:TweenEvent) : void
            {
                twi = null;
                self.tmd.start();
                return;
            }// end function
            );
            }
            if (this.item.tEffect == "lupin")
            {
                this.ttf.text = "";
                this.tmte = new Timer(50, 0);
                num;
                tEffectHandler = function (event:TimerEvent) : void
            {
                if (num < self.item.text.length)
                {
                    var _loc_3:* = num + 1;
                    num = _loc_3;
                    self.ttf.text = String(self.item.text).substr(0, num);
                }
                else
                {
                    self.tmte.stop();
                    self.tmte.removeEventListener(TimerEvent.TIMER, tEffectHandler);
                    self.tmte = null;
                }
                return;
            }// end function
            ;
                this.tmte.addEventListener(TimerEvent.TIMER, tEffectHandler);
            }
            if (outStyle == "fade")
            {
                this.two = BetweenAS3.tween(this, {alpha:0}, {alpha:1}, 0.5, Linear.easeIn);
                this.two.addEventListener(TweenEvent.COMPLETE, function (event:TweenEvent) : void
            {
                two = null;
                self.completeHandler();
                return;
            }// end function
            );
            }
            else if (outStyle != "normal")
            {
                this.two = BetweenAS3.tween(this, {x:this.item.edx, y:this.item.edy}, {x:this.item.x, y:this.item.y}, 1, Quad.easeIn);
                this.two.addEventListener(TweenEvent.COMPLETE, function (event:TweenEvent) : void
            {
                two = null;
                self.completeHandler();
                return;
            }// end function
            );
            }
            this.tmd = new Timer(this.item.duration, 1);
            this.tmd.addEventListener(TimerEvent.TIMER_COMPLETE, function (event:TimerEvent) : void
            {
                if (outStyle == "normal")
                {
                    self.completeHandler();
                }
                else
                {
                    self.two.play();
                }
                return;
            }// end function
            );
            return;
        }// end function

    }
}
