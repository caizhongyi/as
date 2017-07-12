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
	public class Layout extends Sprite{

		var axis = 'x';
		public function Layout() {
			// constructor code
		}
		
		public function setLayout():void{
			for(var i = 0 ; i < this.numChildren ; i ++){
				var o = this.getChildAt(i)
				if(axis == 'x'){
					o.x = o.width * i;
				}
				else{
					o.y = o.height * i;
				}
			}
			return this;
		}
		
		public function add(){
			this.setLayout();
			return this;
		}
		public function remove(){
			this.setLayout();
			return this;
		}

	}
	
}
