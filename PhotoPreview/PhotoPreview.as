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
	import Image;

	public class PhotoPreview extends Sprite{

		var photoSprite = new Sprite();
		public function PhotoPreview() {
			// constructor code
			
			this.addChild(photoSprite);
			//var button = new fl.controls.Button();
			//button.label = '加图';
			//button.x = 200;
			//this.addChild(button);
			//button.addEventListener(MouseEvent.MOUSE_DOWN,function(){
				//addPicture('{F62B8056-2097-4666-B9CC-F76BFCA5A098}.jpg')
			//})
			ExternalInterface.addCallback('addPicture',addPicture);
			//ExternalInterface.call("uploadReady");
		}
		
		public function addPicture(url){
		   var image = new Image(url);
		   photoSprite.addChild(image);
		}


	}
	
}
