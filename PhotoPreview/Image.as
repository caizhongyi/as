package  {
	import flash.external.ExternalInterface;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import fl.motion.MotionEvent;
	import flash.system.LoaderContext;
	import flash.events.*;
	import fl.controls.*;
	import flash.ui.Mouse;
	import flash.display.Bitmap;
	public class Image extends Sprite{

		public var url: String = "";
		public function Image(url) {
			// constructor code
		   
		   var _this = this;
		   this.url = url;
		   var loader : Loader = new Loader(); 
		   loader.load(new URLRequest(url),new LoaderContext(true));
		   loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e : Event){
			//var bitmap:Bitmap = new Bitmap()
			var delButton = new Loader();
			var sprtie = new Sprite();
			sprtie.buttonMode = true;
			sprtie.addChild(delButton);
			loader.addEventListener(MouseEvent.MOUSE_OVER,function(){
				delButton.visible = true;
			});
			delButton.addEventListener(MouseEvent.MOUSE_OUT,function(){
				delButton.visible = false;
			});
			delButton.load(new URLRequest(root.loaderInfo.parameters.removeImage),new LoaderContext(true));
			delButton.addEventListener(MouseEvent.MOUSE_DOWN,remove);
			
			delButton.visible = false;
			delButton.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e : Event){
				sprtie.y = loader.y + loader.height -  sprtie.height;
				sprtie.x = loader.width -  sprtie.width;
			})
			_this.addChild(sprtie);
			//_this.y = _this.height * (_this.parent.getChildIndex(_this) - 1);
			setLayout();
			
			_this.x =  (500 - _this.width) /2 ;  //500宽度的局中
			trace(_this.x)
		   });  
		  
		   this.addChild(loader);
		}
		
		public function remove(e:Event){
			var p = this.parent;
			this.parent.removeChild(this);
			for(var i = 0 ; i < p.numChildren ; i ++){
				var o = p.getChildAt(i);
				o.y =  o.height * i ;
			}
			ExternalInterface.call("remove",this.url)
			return this;
		}

		public function setLayout(){
			
			for(var i = 0 ; i < this.parent.numChildren ; i ++){
				var o = this.parent.getChildAt(i);
				o.y =  o.height * i ;
			}
			
			return this;
			
		}

	}
	
}
