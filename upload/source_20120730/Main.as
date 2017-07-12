package 
{
    import com.*;
    import com.adobe.images.*;
    import com.module.crop.*;
    import fl.controls.*;
    import fl.managers.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
	import flash.external.ExternalInterface;
    import flash.media.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.event.IOErrorEvent;
	import SpriteButton;
	import HisPhoto;
    import nochump.util.zip.*;
    import fl.motion.easing.Back;

    public class Main extends MovieClip
    {
        public var pai:MovieClip;
		
        public var zoomout:SimpleButton;
        public var zoomin:SimpleButton;
        public var img:MovieClip;
        public var saveBtn:Button;
		public var openFileBtn:Button;
		public var openSpriteFileBtn:Sprite;
		public var saveSpriteBtn:Sprite;
        public var display:MovieClip;
 	
        public var paiBtn:Button;
        public var moveMc:MovieClip;
        public var arr:MovieClip;
        public var saveTip:MovieClip;
        public var maskBg:MovieClip;
        public var welcome:MovieClip;
       
		public var uploadText:TextInput;
        private var slide:Slider;
        private var slideBtn:SimpleButton;
        private var isPress:Boolean = false;
        private var crop:Crop;
        
		private var loader:Loader = new Loader();
		//private var borderLoader:Loader;
		
		private var labelUpLoader:Label;

        public var sliderSim:MySlider = new MySlider();
        private var file:FileReference = new FileReference();
        private var imagesFilter:FileFilter = new FileFilter("*.jpg;*.jpeg;*.gif;*.png", "*.jpg;*.jpeg;*.gif;*.png;");
        private var jpg:JPGEncoder;
        private var req:URLRequest;
        private var reqLoader:URLLoader;
        private var cam:Camera;
        private var c:Number = 0;
        private var tmpBmp:Bitmap;
        private var video:Video = new Video(320, 240);
        private var bitmap:Bitmap;
        public static var App:Main;
		
		public var px50:Bitmap;
		public var px100:Bitmap;
		public var px150:Bitmap;
		//public var px150_bd:Bitmap;
		
		
		public var px50_CT:Sprite;
		public var px100_CT:Sprite;
		public var px150_CT:Sprite;
		public var hisImagesSprite:Sprite;
		public var cropSprite:Sprite;
		
		//边框
		public var bloader1 : Loader = new Loader();
		public var bloader2 : Loader = new Loader();
		public var bloader3 : Loader = new Loader();
		
		public var outPut : String;
		//图片的URL
		public var photoURL : String = new String();
		public var photoBroderURL : String = new String();
		//边框的URL
		public var burl : String = new String();
		public var border_id : String = new String();
		//是否可上传
		public var canupload : Boolean = false;
		
		//调试
		public var debug : Boolean = false;
		
		
		public var themes = {
			color   	: 0xf98111,
			themeRoot	: 'themes/'
		};
		
        public function Main()
        {
			/* 多域访问  */
			flash.system.Security.allowDomain("*");
			
			this.tmpBmp = null;
			
			
			/* 加一个背景层 */
			var backgroundSprite : Sprite = new Sprite();
			backgroundSprite.width = this.width;
			backgroundSprite.height = this.height;
			backgroundSprite.graphics.beginFill(0xffffff);
			backgroundSprite.graphics.drawRect(0, 0,  this.width,  this.height);
			backgroundSprite.graphics.endFill();
			this.addChildAt(backgroundSprite,1);
			/* $加一个背景层 */
			
            this.bitmap = new Bitmap();
            App = this;

			px50_CT = new Sprite();
			px100_CT = new Sprite();
			px150_CT = new Sprite();
			cropSprite = new Sprite();
			this.addChild(cropSprite);
			
			px50 = new Bitmap();
			px100 = new Bitmap();
			px150 = new Bitmap();
			px150_bd = new Bitmap();
			
			var buttonUrl:String = '';
			if(this.loaderInfo.parameters.saveBtnImage)
			{
				buttonUrl = this.loaderInfo.parameters.saveBtnImage;
			}
			
			this.saveSpriteBtn = new SpriteButton(buttonUrl);
			if(this.loaderInfo.parameters.openFileBtnImage)
			{
				buttonUrl = this.loaderInfo.parameters.openFileBtnImage;
			}
			this.openSpriteFileBtn = new SpriteButton(buttonUrl);
			this.addChildAt(openSpriteFileBtn,5);
			this.addChildAt(saveSpriteBtn,5);
			
			this.uploadText = new TextInput();
			this.uploadText.enabled = false;
			
			this.labelUpLoader = new Label();
			addChildAt(uploadText,5);
			addChildAt(labelUpLoader,5);
			
			px50_CT.addChild(px50);
			px100_CT.addChild(px100);
			px150_CT.addChild(px150);
			
			
			bloader1.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,IOErrorFun);
			bloader2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,IOErrorFun);
			bloader3.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,IOErrorFun);
			
			px150_CT.addChild(bloader1);
			px100_CT.addChild(bloader2);
			px50_CT.addChild(bloader3);
			
			
            addChildAt(px150_CT,2);
			addChildAt(px100_CT,3);
			addChildAt(px50_CT,4);
			
			
			trace(Base64.decode("aHR0cDovL2xvY2FsaG9zdC9mbGFzaC91cC5waHA/YXV0aD1mc2R3M3IyMzMyJmFwcGlkPTM="));
            this.addChildAt(this.sliderSim, 5);
            this.slide = this.sliderSim as Slider;
            this.img.addChild(this.bitmap);
            this.crop = new Crop(this.stage, this.display.width, this.display.height);
			this.addChildAt(this.crop,2);
			
			if (this.loaderInfo.parameters.border_photo != null)
            {
				trace(this.loaderInfo.parameters.border_photo)
                this.loader.load(new URLRequest(this.loaderInfo.parameters.border_photo), new LoaderContext(true));
				canupload = true; 
				uploadText.text = this.loaderInfo.parameters.border_photo ;
				//this.loader.load(new URLRequest(this.loaderInfo.parameters.border_photo), new LoaderContext(true));
            }
			var hisImagesUrl:Array = new  Array();
			var hisImagesUrlBorder:Array = new  Array();
			if(this.debug)
				hisImagesUrl = hisImagesUrlBorder = 'http://www.zhancai.com/edu/UploadPic/2008/9/8/20089815426444.jpg|http://www.zhancai.com/edu/UploadPic/2008/9/8/20089815426444.jpg|http://www.zhancai.com/edu/UploadPic/2008/9/8/20089815426444.jpg|http://www.zhancai.com/edu/UploadPic/2008/9/8/20089815426444.jpg'.split('|')
			if(this.loaderInfo.parameters.hisImagesUrl != null ){
				hisImagesUrl = this.loaderInfo.parameters.hisImagesUrl.split('|');
			}
			
			if(this.loaderInfo.parameters.hisImagesUrlBorder != null ){
				hisImagesUrlBorder = this.loaderInfo.parameters.hisImagesUrlBorder.split('|');
			}
			this.drawImageBorder();
			this.createHisSprite(10, 390 ,hisImagesUrl ,  hisImagesUrlBorder);
			this.setUI();
            this.addEvent();

            var _loc_1:* = new TextFormat();
            _loc_1.size = 14;
            StyleManager.setStyle("textFormat", _loc_1);
            this.__setProp_openFileBtn_();
            this.__setProp_paiBtn_();
            this.__setProp_saveBtn_();
			
			//this.getImgBorder('http://www.zhancai.com/edu/UploadPic/2008/9/8/20089815426444.jpg');
			
			//声名js调用函数
			
			ExternalInterface.addCallback("useCam",this.useCam);  			 	//切换拍照
			ExternalInterface.addCallback("useupload",this.closePai);		 	//切换上传
			ExternalInterface.addCallback("savePhoto",this.savePhoto);		 	//上传图片
			ExternalInterface.addCallback("getImgBorder",this.getImgBorder); 	//设置边框		
			ExternalInterface.addCallback("addHisImages",this.addHisImages);	//增加历史图片
			this.saveSpriteBtn.disable();
            return;
        }// end function
		
		
		
		function addEvent():void{
			var _this = this;
			this.saveBtn.addEventListener(MouseEvent.CLICK, this.savePhoto);
			this.saveSpriteBtn.addEventListener(MouseEvent.CLICK, this.savePhoto);
            this.openFileBtn.addEventListener(MouseEvent.CLICK, this.openFile);
			this.openSpriteFileBtn.addEventListener(MouseEvent.CLICK, this.openFile);
            this.welcome.select.addEventListener(MouseEvent.CLICK, this.openFile);
            this.welcome.cam.addEventListener(MouseEvent.CLICK, this.useCam);
            this.paiBtn.addEventListener(MouseEvent.CLICK, this.useCam);
            this.pai.draw.addEventListener(MouseEvent.CLICK, this.drawImage);
            this.pai.back.addEventListener(MouseEvent.CLICK, this.closePai);
            this.file.addEventListener(Event.SELECT, this.onFileSelected);
            this.file.addEventListener(Event.COMPLETE, this.onFileLoadCompleted);
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, complete);
			this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,IOErrorFun);
			
		}

		
		function IOErrorFun() : void{
		}
		
		function setUI() : void{

			var _loc_2:Boolean = false;
            this.arr.mouseEnabled = false;
            this.arr.mouseChildren = _loc_2;
            this.moveMc.mouseEnabled = _loc_2;
            this.moveMc.mouseChildren = _loc_2;
			this.mouseEnabled = false;
			this.mouseChildren = true;
			System.useCodePage = true;
            this.saveBtn.enabled = false;
			this.saveTip.mouseEnabled = false;
		    this.saveTip.visible = _loc_2;
			
			//this.setChildIndex(this.saveTip,999);
            this.pai.visible = _loc_2;
			
			/* upload button */
			this.uploadText.x = this.labelUpLoader.x = 10;
			this.uploadText.y = 30;
			this.uploadText.width = 230;

			this.labelUpLoader.width = 300;
			this.labelUpLoader.htmlText ='<font color="#666" font-size="12px">支持jpg、jpeg、png、gif格式，文件大小小于2M</font>';
			this.labelUpLoader.y = this.uploadText.y + 25;
			
			this.openSpriteFileBtn.x = this.openFileBtn.x=this.uploadText.width +  this.uploadText.x + 5;
			this.openSpriteFileBtn.y = this.openFileBtn.y = this.uploadText.y;
			
			//文本边框
			this.uploadText.graphics.lineStyle(1, 0xf98111, 1);
			this.uploadText.graphics.drawRect(-1, -1, this.uploadText.width+1, this.uploadText.height+1); 
			
			/* upload button */
			this.crop.x = this.display.x;
			this.crop.width = 300;
			/* 初始清空 */
			//this.loader = null ; 
		
			this.crop.cacheAsBitmap = false;
			this.px150_CT.width = 180 ;
			this.px150_CT.height = 180;
            this.px150_CT.y = this.crop.y = this.labelUpLoader.y + 30;
			this.px50_CT.x = px100_CT.x = px150_CT.x = this.crop.width  + this.crop.x ;
			this.px100_CT.width = 50 ;
			this.px100_CT.height = 50 ;
			this.px100_CT.y = this.px150_CT.y + this.px150_CT.height  + 17;
			this.px50_CT.width = 30 ;
			this.px50_CT.height = 30 ;
			this.px50_CT.y = this.px100_CT.y + this.px100_CT.height + 17;
			
			this.maskBg.visible = false;
			this.welcome.visible = false;
			
			this.sliderSim.width = 250;
            this.sliderSim.snapInterval = 1e-006;
            this.sliderSim.liveDragging = true;
            this.sliderSim.maximum = 2;
           
            this.sliderSim.y = 350;
			this.zoomin.y = this.zoomout.y = this.sliderSim.y - 6;
			this.zoomin.x = this.crop.x;
			this.sliderSim.x =  this.zoomin.x +  this.zoomin.width + 20;
			this.zoomout.x = this.sliderSim.width + this.sliderSim.x + 5;
			
		}
		
	    function silderVisable(visable : Boolean):void {
			trace(visable)
			this.sliderSim.visible = this.zoomin.visible = this.zoomout.visible = visable;
		}
		
		function drawImageBorder():void{
			this.px50_CT.graphics.lineStyle(1, 0xf98111, 1);
  			this.px50_CT.graphics.drawRect(-1, -1, 31, 31); 
			this.px100_CT.graphics.lineStyle(1, 0xf98111, 1);
  			this.px100_CT.graphics.drawRect(-1, -1, 51, 51); 
			this.px150_CT.graphics.lineStyle(1, 0xf98111, 1);
  			this.px150_CT.graphics.drawRect(-1, -1, 181, 181); 
		}
		//历史图片模块
		function createHisSprite(x:Number,y:Number,urls:Array,broderURLs:Array):Loader{
			if(this.hisImagesSprite == null)
			{
				this.hisImagesSprite = new Sprite();
				this.hisImagesSprite.graphics.beginFill(0xffffff);
				this.hisImagesSprite.graphics.drawRect(0, 0, 300, 50);
				this.hisImagesSprite.graphics.endFill();
				this.addChildAt(this.hisImagesSprite,10);
			}
			var lab : Label = new Label();
			lab.text="我使用过的头像";
			lab.y = y;
			this.addChildAt(lab,5);
			this.hisImagesSprite.x = lab.x =x ;
			this.hisImagesSprite.y = lab.y + lab.height +10 ;
			this.saveSpriteBtn.y = this.saveBtn.y = this.hisImagesSprite.y + this.hisImagesSprite.height +10;
			this.saveSpriteBtn.x = this.saveBtn.x = 10;

			for(var i:String in urls){
				var borderURL = null;
				if(i <  broderURLs.length){
					borderURL = broderURLs[i]
				}
				var s = this.addHisImages(urls[i] +'?' + Math.random() ,borderURL +'?' + Math.random());
				s.x += 60 * i;
			}
			return ;  //最后一个loader;
		}
		
		
		function getScale(scaleVal : int ,val : int  ):int{
			return scaleVal / val;
		}
		
		var tempHisSprite = null;
		//增加历史图片
		function addHisImages(url:String , borderURL:String){
			var _this = this;
			var sprite : HisPhoto = new HisPhoto(borderURL,50 , 50 );
			sprite.name = "photosprite";
			sprite.graphics.lineStyle(1, 0xffffff, 1);
  			sprite.graphics.drawRect(-1, -1, 51, 51); 
			sprite.useHandCursor = true;
			sprite.mouseEnabled = true;
			sprite.graphics.beginFill(0xffffff);
			sprite.graphics.drawRect(0, 0, 50, 50);
			sprite.graphics.endFill();
			sprite.buttonMode = true;
			sprite.url = borderURL;
			sprite.width = 50 ; 
			sprite.height = 50;
			sprite.addEventListener(MouseEvent.CLICK,function(){
				_this.tmpBmp = sprite.loader.content as Bitmap;
				trace(_this.tmpBmp);
				//this.photoURL = normal;
				_this.photoBroderURL = sprite.url;
				trace(_this.photoBroderURL);
				_this.uploadText.text = _this.photoBroderURL;
				trace(_this.photoBroderURL);
				//getImgBorder(broderURL);
				_this.setViewPhotos(sprite.tempBimtmap.bitmapData)
				_this.complete(null, false);
				_this.silderVisable(false);
				_this.clearImgBorder();
				if(tempHisSprite)tempHisSprite.unchecked();
				tempHisSprite = sprite.checked();
			
			});
			this.hisImagesSprite.addChild(sprite);
			var hisLoader:Loader = new Loader();
			var loadercontext:LoaderContext = new LoaderContext(true);
			//loadercontext.applicationDomain=ApplicationDomain.currentDomain;
			hisLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event){
				 var bitmap:Bitmap = new Bitmap(); 
                 try {  
                    bitmap = hisLoader.content;
                 } catch (err:SecurityError) {  
				   //if(this.loaderInfo.parameters.callback)
				   //   ExternalInterface.call(this.loaderInfo.parameters.callback, hisLoader.contentLoaderInfo.bytes);
                   hisLoader.loadBytes(hisLoader.contentLoaderInfo.bytes);  
                   return;  
            	 }  
           		 var bitmapdata : BitmapData= new BitmapData(50, 50);  
            	 bitmapdata.draw(bitmap); 
				 bitmap.smoothing = true;
				 bitmap.width = 50; 
				 bitmap.height = 50 ;
     			 sprite.tempBimtmap = bitmap;
			});
			hisLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,IOErrorFun);
			hisLoader.load(new URLRequest(url),loadercontext );
			
			return sprite;
		}
		

		
        function useCam(event:MouseEvent) : void
        {
            this.pai.visible = true;
			this.pai.height = this.height;
			this.pai.width =520 ;
            this.startupCam();
            return;
        }// end function
		
		
        private function closePai(event:MouseEvent) : void
        {
            this.pai.visible = false;
            this.video.attachCamera(null);
            return;
        }// end function

        private function drawImage(event:MouseEvent) : void
        {
            var _loc_4:drawBox = null;
            var _loc_2:* = new drawBox();
            var _loc_3:* = new Bitmap();
            _loc_3.bitmapData = new BitmapData(this.video.width, this.video.height);
            _loc_3.bitmapData.draw(this.video);
            _loc_3.width = 100 - 4;
            _loc_3.height = 75 - 4;
            var _loc_5:int = 2;
            _loc_3.y = 2;
            _loc_3.x = _loc_5;
            _loc_2.addChild(_loc_3);
            _loc_5 = this;
            var _loc_6:* = this.c + 1;
            //_loc_5.c = _loc_6;
            if (this.c > 4)
            {
                this.c = 1;
                this.pai.list.removeChildAt(this.c);
            }
            if (this.c == 1)
            {
                _loc_2.x = 10;
                _loc_2.y = 7;
            }
            else
            {
                _loc_4 = this.pai.list.getChildAt((this.pai.list.numChildren - 1)) as drawBox;
                _loc_2.x = _loc_4.x + _loc_4.width + 12;
                _loc_2.y = _loc_4.y;
            }
            _loc_2.buttonMode = true;
            _loc_2.addEventListener(MouseEvent.CLICK, this.useImage);
            this.pai.list.addChild(_loc_2);
            return;
        }// end function

        private function useImage(event:MouseEvent) : void
        {
            if (this.loader == null)
            {
                this.loader = new Loader();
            }
            var _loc_2:* = event.target as drawBox;
            this.tmpBmp = _loc_2.getChildAt((_loc_2.numChildren - 1)) as Bitmap;
            var _loc_3:Boolean = false;
            this.pai.visible = false;
            this.welcome.visible = _loc_3;
            this.video.attachCamera(null);
            this.video.clear();
            this.complete();
            return;
        }// end function

        private function openFile(event:MouseEvent) : void
        {
            this.file.browse([this.imagesFilter]);
            return;
        }// end function

        private function onFileSelected(event:Event) : void
        {
            this.welcome.visible = false;
            this.file.load();
			this.uploadText.text = this.file.name;
			this.silderVisable(true);
            return;
        }// end function

        private function startupCam() : void
        {
            this.cam = Camera.getCamera();
            if (this.cam)
            {
                this.video.attachCamera(this.cam);
                this.video.x = 85;
                this.video.y = 41;
                this.pai.addChild(this.video);
                this.cam.setKeyFrameInterval(100);
                this.cam.setMode(this.video.width, this.video.height, 15, false);
                this.pai.draw.enabled = true;
            }
            else
            {
                this.pai.draw.enabled = false;
            }
            return;
        }// end function

        private function onFileLoadCompleted(event:Event) : void
        {
            this.loader.loadBytes(this.file.data);
			if(tempHisSprite)tempHisSprite.unchecked();
            return;
        }// end function

        private function onSelected(event:Event) : void
        {
            this.loader.loadBytes(this.file.data);
            return;
        }// end function
		
		public var isFirstLoad = true;
        private function complete(event:Event = null , isRelease : Boolean = true ) : void
        {
			var _this = this;
            var _loc_2:Bitmap = null;
            if (event != null)
            {
				if(isFirstLoad){
					var photoLoader : Loader  = new Loader();
					photoLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,IOErrorFun);
					photoLoader.load(new URLRequest(this.loaderInfo.parameters.photo),new LoaderContext(true) );
					photoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event){
					 var bitmap:Bitmap = new Bitmap(); 
               	 	 try {  
               	     	bitmap = photoLoader.content;
                 	 } catch (err:SecurityError) {  
				  
                   	 photoLoader.loadBytes(photoLoader.contentLoaderInfo.bytes);  
                      return;  
            	 }  
           		  _this.setViewPhotos(bitmap.bitmapData);
				  });
				  isRelease = false;
				  isFirstLoad = false;
				}
				
				_loc_2 = this.loader.content as Bitmap;
                _loc_2.smoothing = true;
            	
			}
            else
            {
                _loc_2 = new Bitmap(this.tmpBmp.bitmapData.clone());
				_loc_2.smoothing = true;
            }
			canupload = true;
			trace(_loc_2)
            this.crop.addImage(_loc_2);
			if(isRelease)
            	this.release();
            this.crop.scale = 0.001;
            this.slide.maximum = 1;
            this.slide.minimum = this.crop.scale;
            this.slide.value = this.slide.minimum;
            var _loc_3:Boolean = true;
            this.slide.useHandCursor = true;
            this.slide.buttonMode = _loc_3;
			trace(this.slide.minimum)
            if (this.slide.minimum >= this.slide.maximum)
            {
               this.silderVisable(false);
            }
            else
            {
                this.silderVisable(true);
            }
			
            this.crop.addEventListener(Crop.ON_MOUSE_RELEASE, this.release);
            this.crop.addEventListener("onMouseWheel", this.onMouseWheel);
            this.slide.addEventListener(Event.CHANGE, this.doChange);
            this.zoomin.addEventListener(MouseEvent.CLICK, this.zoomIn);
            this.zoomout.addEventListener(MouseEvent.CLICK, this.zoomOut);
            return;
        }// end function

        private function zoomIn(event:Event) : void
        {
            this.slide.value = this.slide.value - 0.05;
            this.slide.dispatchEvent(new Event(Event.CHANGE));
            this.release();
            return;
        }// end function

        private function zoomOut(event:Event) : void
        {
            this.slide.value = this.slide.value + 0.05;
            this.slide.dispatchEvent(new Event(Event.CHANGE));
            this.release();
            return;
        }// end function

        private function onMouseWheel(event:Event) : void
        {
            this.slide.value = this.crop.scale;
            return;
        }// end function
		
		//设置右边的图片 BitmapData ：图片源
		private function setViewPhotos(bitmapData : BitmapData){
			this.bitmap.bitmapData = bitmapData;
			
            if (this.bitmap != null)
            {
                this.bitmap.smoothing = true;
            }
            this.saveBtn.enabled = true;
            this.saveSpriteBtn.enable();
			
			px50.bitmapData = this.bitmap.bitmapData.clone();
			px50.scaleX =   30 / this.bitmap.width ;
			px50.scaleY = 	30  / this.bitmap.height ;
			
			px100.bitmapData = this.bitmap.bitmapData.clone();
			px100.scaleX =   50 / this.bitmap.width ;
			px100.scaleY = 	50 / this.bitmap.height ;
			
			px150.bitmapData = this.bitmap.bitmapData.clone();
			px150.scaleX =   180 / this.bitmap.width ;
			px150.scaleY = 	180 / this.bitmap.height ;
		}
		
		//右侧力片重置
        private function release(event:Event = null) : void
        {			
			this.setViewPhotos(this.crop.cropImage);
			
        }// end function
		
		//清除边框
		public function clearImgBorder(){
			bloader1.unload();
			bloader2.unload();
			bloader3.unload();
			return this;
		}
		
		//加载边框
		public function getImgBorder(url , id) : Bitmap{
			bloader1.load(new URLRequest(url), new LoaderContext(true));
			bloader2.load(new URLRequest(url), new LoaderContext(true));
			bloader3.load(new URLRequest(url), new LoaderContext(true));
			bloader1.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e){
				bloader1.width = bloader1.height = 180;
			});
			bloader2.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e){
				bloader2.width = bloader2.height = 50;
			});
			bloader3.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e){
				bloader3.width = bloader3.height = 30;
			});
			this.release();
			this.burl = url;
			this.border_id = id;
			return;
		
		}
		
        public function getImg() : Bitmap
        {
            var _loc_1:* = new Bitmap();
            _loc_1.bitmapData = this.bitmap.bitmapData.clone();
            _loc_1.smoothing = true;
            return _loc_1;
        }// end function

        private function doChange(event:Event) : void
        {
            this.crop.scale = this.slide.value;
            this.release();
            return;
        }// end function
		
		//获取上传图片 小于180大小的则为原图~！
		private function getupLoadImage(bitmap :BitmapData , newBitmap : BitmapData){
			if(bitmap.width > 180 && bitmap.height > 180){
				return newBitmap;
			}
			else{
				return bitmap;
			}
		}
		
        private function savePhoto(event:Event) : void
        {
			 //提效之前事件beforeUpload
			 if (ExternalInterface.available) {
			 	var result = ExternalInterface.call("beforeUpload");
				if(result == false){ return; }
			 }
			 
			 //上传文本框付值
			 if(!canupload || uploadText.text == ''){
				return ;
			 }

            this.saveTip.visible = true;
			this.openSpriteFileBtn.disable();
			this.saveSpriteBtn.disable();
			
			this.saveTip.tip.text = "正在处理照片...";
			
            var _loc_2:ZipOutput = new ZipOutput();
            var _loc_3:Number = 100;
            this.jpg = new JPGEncoder(_loc_3);
            var _loc_4:BitmapData = new BitmapData(180,180);
			this.saveTip.tip.text = "begindraw...";
			try{
			_loc_4.draw(this.px150);
			}
			catch(e){
			this.saveTip.tip.text = e;
			return ;
			}
			
			_loc_4 = getupLoadImage(this.crop.cropImage,_loc_4);
            var _loc_5:* = this.jpg.encode(_loc_4);
			
			
			
            var _loc_6:* = new ZipEntry("150x150.jpg");
            _loc_2.putNextEntry(_loc_6);
            _loc_2.write(_loc_5);
            _loc_2.closeEntry();
            this.jpg = new JPGEncoder(_loc_3);
			
			
			
            var _loc_7:BitmapData = new BitmapData(50,50);
			_loc_7.draw(this.px100)
			
			
			
            var _loc_8:* = this.jpg.encode(_loc_7);
            _loc_6 = new ZipEntry("100x100.jpg");
            _loc_2.putNextEntry(_loc_6);
            _loc_2.write(_loc_8);
            _loc_2.closeEntry();
            this.jpg = new JPGEncoder(_loc_3);
			
			
			
            var _loc_9:BitmapData = new BitmapData(30,30);
			_loc_9.draw(this.px50)
            var _loc_10:* = this.jpg.encode(_loc_9);
            _loc_6 = new ZipEntry("50x50.jpg");
            _loc_2.putNextEntry(_loc_6);
            _loc_2.write(_loc_10);
            _loc_2.closeEntry();
			
			
			/*
            this.jpg = new JPGEncoder(_loc_3);
            var _loc_11:* = this.jpg.encode(this.crop.cropImage);
            _loc_6 = new ZipEntry("180x180.jpg");
            _loc_2.putNextEntry(_loc_6);
            _loc_2.write(_loc_11);
            _loc_2.closeEntry();
			*/
            _loc_2.finish();
			
            this.saveTip.tip.text = "上传中...";
			
            var _loc_12:* = this.jpg.encode(this.crop.cropImage);
			trace(_loc_5.length)
            if (this.loaderInfo.parameters.upurl != null || this.debug)
            {
				var url:String = Base64.decode(this.loaderInfo.parameters.upurl == null ? '?' : this.loaderInfo.parameters.upurl);
				if(url.indexOf("?") != -1)
				{
					url += "&";
				}else{
					url += "?";
				}
				url += "size=" + _loc_5.length;

				url += '&url='+ this.uploadText.text +'&border_id='+ this.border_id;
				trace(url)
				outPut = url;
				//url='http://192.168.50.29/upload.php'
				
                this.req = new URLRequest(url);
				//var post_data = new URLVariables();
				//post_data.key  = "﻿de43f380e15429c59da0afba830d8188";
				//this.req.data  = post_data;
				//this.req.contentType = 'multipart/form-data;';
				
				this.req.data = _loc_5;
                this.req.method = URLRequestMethod.POST;
                this.req.contentType = "application/octet-stream";
				
				
                this.reqLoader = new URLLoader();
				this.reqLoader.dataFormat = URLLoaderDataFormat.BINARY;
                this.reqLoader.load(this.req);
                this.reqLoader.addEventListener(Event.COMPLETE, this.infoCompleteHandler);
                this.reqLoader.addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
				
				/*function  getBytes(imageType : String , bitmap : Bitmap):ByteArray{
					  var bytes:ByteArray = null;
					  if(imageType == 'png'){
					  	 bytes = PNGEncoder.encode(bitmap.bitmapData);
					  }
					  else{
						 var encoder:JPGEncoder = new JPGEncoder(100);
           				 bytes = encoder.encode(bitmap.bitmapData);
					  }
					  
				}*/
            }
            return;
        }// end function

        private function infoCompleteHandler(event:Event) : void
        {
                this.saveTip.visible = false;
				canupload = false;
				this.saveTip.tip.text = "";
				if (this.loaderInfo.parameters.callback != null)
				{//this.reqLoader.data
					ExternalInterface.call(this.loaderInfo.parameters.callback, this.debug ? outPut : this.reqLoader.data );
				}
          	    this.openSpriteFileBtn.enable();
            return;
        }// end function

        private function errorHandler(event:Event) : void
        {
            ExternalInterface.call(this.loaderInfo.parameters.callback, this.debug ? outPut : -1);
            return;
        }// end function

        function __setProp_openFileBtn_()
        {
            try
            {
                this.openFileBtn["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            this.openFileBtn.emphasized = false;
            this.openFileBtn.enabled = true;
            this.openFileBtn.label = "浏览文件";
            this.openFileBtn.labelPlacement = "right";
            this.openFileBtn.selected = false;
            this.openFileBtn.toggle = false;
			if(!this.debug)
           	 this.openFileBtn.visible = false;
            try
            {
                this.openFileBtn["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_paiBtn_()
        {
            try
            {
                this.paiBtn["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            this.paiBtn.emphasized = false;
            this.paiBtn.enabled = true;
            this.paiBtn.label = "拍摄图片";
            this.paiBtn.labelPlacement = "right";
            this.paiBtn.selected = false;
            this.paiBtn.toggle = false;
            if(!this.debug)
				this.paiBtn.visible = false;
            try
            {
                this.paiBtn["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_saveBtn_()
        {
            try
            {
                this.saveBtn["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }

            this.saveBtn.emphasized = false;
            this.saveBtn.enabled = false;
            this.saveBtn.label = "保存图片";
            this.saveBtn.labelPlacement = "right";
            this.saveBtn.selected = false;
            this.saveBtn.toggle = false;
			if(!this.debug)
            	this.saveBtn.visible = false;
			//var btnload:Loader = new Loader();
			//btnload.load(new URLRequest('http://127.0.0.1/czy.js/upload/save.png'));
			//btnload.contentLoaderInfo.addEventListener(Event.COMPLETE, this.btnloadComplete);
			//if(btnload.content != null)
				
            try
            {
                this.saveBtn["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function
		
		
		
		
		
    }
}
