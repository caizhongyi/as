package 
{
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.system.*;
    import flash.text.*;
	
	
	/*
		js 调用 flash
			init  初始化(data:Array, clickcallback:String, endcallback:String)  
				data : 初化化数据 [{name:"itouch4", index:"1671"}]
				clickcallback :  点击开始的回调
				endcallback	  :  结束回调
			start 开始
		js 回调 
			
			
	*/
    public class Main extends Sprite
    {
        public var overbtn:SimpleButton;
        public var btn:SimpleButton;
        public var info:TextField;
        public var mc:MovieClip;
        private var bClick:Boolean = false;
        private var zero:Number = 0;
        private var _callback:String;
        private var _callbackend:String;
        private var __onend_func:String;
        private var _onready:String = "";
        private var testdata:Array;
        private var xmldata:Array;
        private var nIndex:String = "-1";
			
		var isTest  = true;
		
        public function Main()
        {
            this.testdata = [
							 {name:"itouch4", index:"0"}, 
							 {name:"itouch4", index:"0"}, 
							 {name:"itouch4", index:"0"}, 
							 {name:"itouch4", index:"0"}, 
							 {name:"itouch4", index:"0"}, 
							 {name:"itouch4", index:"0"}
							 ];
			
			this.GetParam();
            loaderInfo.addEventListener(Event.COMPLETE, this.on_Complete);
			
			//test init
			if(isTest)
				this.init(this.testdata,'onstart','onend');
			
            if (ExternalInterface.available)
            {
                ExternalInterface.addCallback("init", this.init);
                ExternalInterface.addCallback("start", this.onStart);
            }
            this.btn.addEventListener(MouseEvent.CLICK, this.OnClick);
            Security.allowDomain("*");
            Security.allowInsecureDomain("*");
            return;
        }// end function

        private function GetParam()
        {
            var _loc_1:* = root.loaderInfo.parameters;
            if (_loc_1["onready"] != null && _loc_1["onready"] != undefined && _loc_1["onready"] != "")
            {
                this._onready = _loc_1["onready"];
            }
            return;
        }// end function

        private function on_Complete(event:Event) : void
        {
            var e:* = event;
            try
            {
                if (this._onready != "")
                {
                    ExternalInterface.call(this._onready);
                }
            }
            catch (e)
            {
            }
            return;
        }// end function

        public function init(param1:Array, param2:String, param3:String) : void
        {
			this.xmldata = param1 ;
            this.overbtn.visible = false;
            this.btn.visible = true;
            this._callback = param2;
            this._callbackend = param3;
			
            this.InitLigths();
			
            var _loc_4:int = 0;
            var _loc_5:* = 0;
            while (_loc_5 < this.xmldata.length)
            {
                if (this.xmldata[_loc_5].index == "0")
                {
					
                    var _loc_6 = this;
                    var _loc_7:* = this.zero + 1;
                    _loc_6.zero = _loc_7;
                    _loc_4 = _loc_4 - 1;
                    this.xmldata[_loc_5].index = String(_loc_4);
					
				}
				
                _loc_5 = _loc_5 + 1;
			}
			
			var plate:Image = new Image('images/plate.png');
			this.mc.plate.addChild(plate);
			
			
			var goBtn:Image = new Image('images/go.png');
			//var goHover:Image = new Image('images/go-hover.png');
			var goDown:Image = new Image('images/go-down.png');
			
			
			this.btn.hitTestState = goDown;
			this.btn.overState  = goBtn;
			this.btn.downState = goDown;
			this.btn.upState= goBtn;
			this.btn.x = - 35;
			this.btn.y = - 30;
			
			var mcPoint:Image = new Image('images/point.png');
			mcPoint.x = -20;
			mcPoint.y = -150;
			this.mc.mcPoint.addChild(mcPoint);
            
			
			this.mc.item1.txt.text = this.xmldata[0].name;
            this.mc.item1.rotationZ = 0;
            this.mc.item2.txt.text = this.xmldata[1].name;
            this.mc.item2.rotationZ = 60;
            this.mc.item3.txt.text = this.xmldata[2].name;
            this.mc.item3.rotationZ = -60;
            this.mc.item4.txt.text = this.xmldata[3].name;
            this.mc.item4.rotationZ = 0;
            this.mc.item5.txt.text = this.xmldata[4].name;
            this.mc.item5.rotationZ = 60;
            this.mc.item6.txt.text = this.xmldata[5].name;
            this.mc.item6.rotationZ = -60;
            /*this.mc.item7.txt.text = this.xmldata[6].name;
            this.mc.item7.rotationZ = -75;
            this.mc.item8.txt.text = this.xmldata[7].name;
            this.mc.item8.rotationZ = -45;
            this.mc.item9.txt.text = this.xmldata[8].name;
            this.mc.item9.rotationZ = -15;
            this.mc.item10.txt.text = this.xmldata[9].name;
            this.mc.item10.rotationZ = 15;
            this.mc.item11.txt.text = this.xmldata[10].name;
            this.mc.item11.rotationZ = 45;
            this.mc.item12.txt.text = this.xmldata[11].name;
            this.mc.item12.rotationZ = 75;*/
            return;
        }// end function

        public function onStart(param1:String, param2:String) : void
        {
            var pointerAngle:Number;
            var lastAngle:Number;
            var rounds:Number;
            var speed:Number;
            var round:Number;
            var totalAngle:Number;
            var totalFrame:Number;
            var acc:Number;
            var run:Function;
            var randomIndex:int;
            var index:* = param1;
            var onend_func:* = param2;
            this.bClick = true;
            if (onend_func)
            {
                this.__onend_func = onend_func;
            }
            this.nIndex = index;
			
            if (this.nIndex == "-1")
            {
                this.bClick = false;
                return;
            }
            if (this.nIndex == "0")
            {
                randomIndex = (int(Math.random() * this.zero) + 1) * -1;
                this.nIndex = String(randomIndex);
            }
			
            run = function (event:Event) : void
            {
                lights();
                mc.mcPoint.rotation = mc.mcPoint.rotation + speed;
                speed = speed - acc;
                if (speed <= 0)
                {
                    speed = 0;
                    mc.mcPoint.removeEventListener(Event.ENTER_FRAME, run);
                    bClick = false;
                    if (ExternalInterface.available)
                    {
                        ExternalInterface.call(__onend_func);
                        ExternalInterface.call(_callbackend);
                    }
                }
                return;
            }// end function
            ;
            pointerAngle = this.mc.mcPoint.rotation;
			
            lastAngle = this.getPrizeAngle(this.nIndex);
			
			
            rounds = 2;
            speed = 50;
            totalAngle = rounds * 360 + (lastAngle - pointerAngle);
            totalFrame = 2 * totalAngle / speed;
            acc = speed / (totalFrame - 1);
			
            this.mc.mcPoint.addEventListener(Event.ENTER_FRAME, run);
            return;
        }// end function

        private function OnClick(event:MouseEvent) : void
        {
         	//test start
			if(isTest)
				this.onStart(0,'noPrize');
            if (this.bClick)
            {
                return;
            }
            if (this._callback && this._callback != "")
            {
                ExternalInterface.call(this._callback);
            }
            return;
        }// end function

        private function getPrizeAngle(param1:String) : Number
        {
            var _loc_2:* = NaN;
			
            switch(param1)
            {
                case this.xmldata[0].index:
                {
                    _loc_2 = 0;
                    break;
                }
                case this.xmldata[1].index:
                {
                    _loc_2 = 70;
                    break;
                }
                case this.xmldata[2].index:
                {
                    _loc_2 = 130;
                    break;
                }
                case this.xmldata[3].index:
                {
                    _loc_2 = 180;
                    break;
                }
                case this.xmldata[4].index:
                {
                    _loc_2 = 240;
                    break;
                }
                case this.xmldata[5].index:
                {
                    _loc_2 = 300;
                    break;
                }
                case this.xmldata[6].index:
                {
                    _loc_2 = 360;
                    break;
                }
                /*case this.xmldata[7].index:
                {
                    _loc_2 = 225;
                    break;
                }
                case this.xmldata[8].index:
                {
                    _loc_2 = 255;
                    break;
                }
                case this.xmldata[9].index:
                {
                    _loc_2 = 285;
                    break;
                }
                case this.xmldata[10].index:
                {
                    _loc_2 = 315;
                    break;
                }
                case this.xmldata[11].index:
                {
                    _loc_2 = 345;
                    break;
                }*/
                default:
                {
					
                    this.info.visible = true;
                    this.info.text = "·µ»ؽ±ƷID¸úתÅÌÉϽ±ƷID²»¶ÔӦ£¡";
                    break;
                }
            }
			
            return _loc_2;
        }// end function

        private function InitLigths() : void
        {
            this.mc.light1.alpha = 0.8;
            this.mc.light2.alpha = 0.8;
            this.mc.light3.alpha = 0.8;
            this.mc.light4.alpha = 0.8;
            this.mc.light5.alpha = 0.8;
            this.mc.light6.alpha = 0.8;
            this.mc.light7.alpha = 0.8;
            this.mc.light8.alpha = 0.8;
            this.mc.light9.alpha = 0.8;
            this.mc.light10.alpha = 0.8;
            this.mc.light11.alpha = 0.8;
            this.mc.light12.alpha = 0.8;
            return;
        }// end function

        private function lights() : void
        {
            if (this.mc.mcPoint.rotation >= 1 && this.mc.mcPoint.rotation <= 29)
            {
                this.mc.light1.alpha = 1;
                this.mc.light1.removeEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            else
            {
                this.mc.light1.addEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            if (this.mc.mcPoint.rotation >= 31 && this.mc.mcPoint.rotation <= 59)
            {
                this.mc.light2.alpha = 1;
                this.mc.light2.removeEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            else
            {
                this.mc.light2.addEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            if (this.mc.mcPoint.rotation >= 61 && this.mc.mcPoint.rotation <= 89)
            {
                this.mc.light3.alpha = 1;
                this.mc.light3.removeEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            else
            {
                this.mc.light3.addEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            if (this.mc.mcPoint.rotation >= 91 && this.mc.mcPoint.rotation <= 119)
            {
                this.mc.light4.alpha = 1;
                this.mc.light4.removeEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            else
            {
                this.mc.light4.addEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            if (this.mc.mcPoint.rotation >= 121 && this.mc.mcPoint.rotation <= 149)
            {
                this.mc.light5.alpha = 1;
                this.mc.light5.removeEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            else
            {
                this.mc.light5.addEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            if (this.mc.mcPoint.rotation >= 151 && this.mc.mcPoint.rotation <= 179)
            {
                this.mc.light6.alpha = 1;
                this.mc.light6.removeEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            else
            {
                this.mc.light6.addEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            if (this.mc.mcPoint.rotation >= -179 && this.mc.mcPoint.rotation <= -151)
            {
                this.mc.light7.alpha = 1;
                this.mc.light7.removeEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            else
            {
                this.mc.light7.addEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            if (this.mc.mcPoint.rotation >= -149 && this.mc.mcPoint.rotation <= -121)
            {
                this.mc.light8.alpha = 1;
                this.mc.light8.removeEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            else
            {
                this.mc.light8.addEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            if (this.mc.mcPoint.rotation >= -119 && this.mc.mcPoint.rotation <= -91)
            {
                this.mc.light9.alpha = 1;
                this.mc.light9.removeEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            else
            {
                this.mc.light9.addEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            if (this.mc.mcPoint.rotation >= -89 && this.mc.mcPoint.rotation <= -61)
            {
                this.mc.light10.alpha = 1;
                this.mc.light10.removeEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            else
            {
                this.mc.light10.addEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            if (this.mc.mcPoint.rotation >= -59 && this.mc.mcPoint.rotation <= -31)
            {
                this.mc.light11.alpha = 1;
                this.mc.light11.removeEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            else
            {
                this.mc.light11.addEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            if (this.mc.mcPoint.rotation >= -29 && this.mc.mcPoint.rotation <= -1)
            {
                this.mc.light12.alpha = 1;
                this.mc.light12.removeEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            else
            {
                this.mc.light12.addEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            return;
        }// end function

        public function lightOff(event:Event) : void
        {
            var _loc_2:* = MovieClip(event.target);
            if (_loc_2.alpha != 0.8)
            {
                _loc_2.alpha = _loc_2.alpha - 0.07;
            }
            if (_loc_2.alpha <= 0.8)
            {
                _loc_2.alpha = 0.8;
                _loc_2.removeEventListener(Event.ENTER_FRAME, this.lightOff);
            }
            return;
        }// end function

    }
}
