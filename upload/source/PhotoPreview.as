package  {
	
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
	
	
	public class PhotoPreview  extends Sprite{
	
		public var border = new  Loader();	 //图片外加层
		public var photo  = new  Bitmap();	 //显示的图片
		public var bcolor = 0xf98111;        //边框颜色
		
		public function PhotoPreview(width = 100 , height = 100) {
			// constructor code
			this.width = width ;
			this.height = height;
			
			this.graphics.lineStyle(1, bcolor , 1);
  			this.graphics.drawRect(-1, -1, width + 1, height + 1); 
			
			this.addChild(photo);
			this.addChild(border);
			
		}
		
		public function loadPhoto(url){
			var loader:Loader = new Loader();
			var loadercontext:LoaderContext = new LoaderContext(true);
			//loadercontext.applicationDomain=ApplicationDomain.currentDomain;
			loader.load(url);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event){
				photo = loader.content as Bitmap;
		 	}
			return this;
		}
		
		public function loadBorder(url){
			var loader:Loader = new Loader();
			var loadercontext:LoaderContext = new LoaderContext(true);
			//loadercontext.applicationDomain=ApplicationDomain.currentDomain;
			loader.load(url);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event){
				border = loader;
		 	}
			return this;
		}

	}
	
}
