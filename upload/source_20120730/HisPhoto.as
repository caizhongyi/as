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
	
	public class HisPhoto extends  Sprite {
		
		public var url : String;
		public var borderURL : String; 
		public var tempBimtmap = new Bitmap();
		public var loader:Loader = new Loader();
		
		public function HisPhoto(url:String , width: Number = 50 , height:Number = 50 ) {
			var _this = this;
			// constructor code
			this.width = width;
			this.height = height;
			this.url = url ;
			
			var loadercontext:LoaderContext = new LoaderContext(true);
			//loadercontext.applicationDomain=ApplicationDomain.currentDomain;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event){
				
				 var bitmap:Bitmap = new Bitmap(); 
                 try {  
                    bitmap = loader.content;
                 } catch (err:SecurityError) {  
				   //if(this.loaderInfo.parameters.callback)
				   //   ExternalInterface.call(this.loaderInfo.parameters.callback, hisLoader.contentLoaderInfo.bytes);
                   loader.loadBytes(loader.contentLoaderInfo.bytes);  
                   return;  
            	 }  
           		 var bitmapdata : BitmapData= new BitmapData(width, height);  
            	 bitmapdata.draw(bitmap); 
				 bitmap.smoothing = true;
				 bitmap.width = width; 
				 bitmap.height = height;
				
				 //bitmap.name = "hisphoto";
				/* var bitmap : Bitmap = new Bitmap();
				 bitmap.bitmapData = (e.target.content as Bitmap).bitmapData.clone();
				 
				*/
				
     			 _this.addChild(bitmap);
			});
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(){});
			loader.load(new URLRequest(url),loadercontext );
			return ;
		}
		
		
		public function checked(){
			this.graphics.lineStyle(1, 0xf98111, 1);
  			this.graphics.drawRect(-1, -1, 51 , 51); 
			return this;
		}
		
		public function unchecked(){
			this.graphics.clear();
			return this;
			//this.graphics.lineStyle(1, 0xf98111, 1);
  			//this.graphics.drawRect(-1, -1, this.width, this.height); 
		}
		public function addBorder(url:String , width : Number = 50, height : Number = 50){
			var loader : Loader = new Loader();
			loader.width = width ?  width : this.width;
			loader.height = height ?  height : this.height;
			loader.load(new URLRequest(url), new LoaderContext(true));
			this.addChild(loader);
			return this;
		}
	}
	
}
