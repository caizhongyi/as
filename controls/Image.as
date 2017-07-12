package  {
	
	import flash.external.ExternalInterface;
	import flash.display.*;
	import flash.net.URLRequest;
	import fl.motion.MotionEvent;
	import flash.system.LoaderContext;
	import flash.events.*;
	import fl.controls.*;
	import flash.ui.Mouse;
	import flash.display.Bitmap;
	
	public class Image extends Sprite{

		public function Image(url,callback = null) {
			// constructor code
		   var that = this;
		   var loader : Loader = new Loader(); 
		   loader.load(new URLRequest(url),new LoaderContext(true));
		   loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e : Event){
				//var bitmap :Bitmap = new Bitmap(e.target.content.bitmapData); 
				////that.width = bitmap.width;
				//that.height = bitmap.height;
				///that.addChild(bitmap);
				///trace('loaded ' + url);
				callback && callback.call(that,e);
		   })
		   this.addChild(loader);
		}

	}
	
}
