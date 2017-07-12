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
	
    import nochump.util.zip.*;
    import fl.motion.easing.Back;

    public class SpriteButton extends Sprite{
			public var url : String = '' ; 
			public function SpriteButton(url:String , callback : Function = null)
        	{	
				var _this = this;
				if(url != '' && url !=null)
				{	
					url = url;
					trace(url);
					
					this.buttonMode = true;
					this.useHandCursor = true;
					this.mouseEnabled = true;
					this.mouseChildren = false;
					
					var loader:Loader = new Loader();
					loader.load(new URLRequest(url),new LoaderContext(true));
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,IOErrorFun);
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event){
						
						var b:Bitmap = (e.target.content as Bitmap);
						_this.addChild(b);
						_this.graphics.beginFill(0xffffff);
						_this.graphics.drawRect(0, 0, b.width, b.height);
						_this.width = b.width;
						_this.height = b.height;
						_this.graphics.endFill();
						callback && callback();
						
					});
				}
            	return;
      		}// end function
			
			public function disable(){
			 	this.mouseEnabled = false;
			 	this.buttonMode = false;
			 	return this;
			}
	
			public function enable(){
		 		this.mouseEnabled = true;
			 	this.buttonMode = true;
				return this;
			}
			function IOErrorFun(){
			
			}
	}

}