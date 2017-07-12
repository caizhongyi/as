package  {
	import flash.display.Sprite;
	
	public class ImageButton extends Sprite{
		
		public var image:Bitmap ; 
		
		public function ImageButton(url:String = null) {
			// constructor code
			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseEnabled = true;
			this.mouseChildren = false;
			this.loadImage(url);
		}
		
		public function width(width:Number = this.width):Number{
		   if(width == this.width)
		   {
			   return width;
		   }
		   this.width = width;
		   this.image.width = width ;
		   return this;
		}
		
		public function height(height:Number = this.height):Number{
		   if(height == this.height)
		   {
			   return height;
		   }
		   this.height = height;
		   this.image.height = height ;
		   return this;
		}
		
		public function setBorder(color:uint = 0xf98111,thickness:Number = 1,  alpha : Number = 1.0):Sprite{
			this.graphics.lineStyle(thickness, color,alpha );
  			this.graphics.drawRect(-1, -1,this.width, this.height); 
			return this;
		}
		
		
		/* 创建图片按扭 */
		public function loadImage(url:String):Sprite{
			if(url != '' && url !=null)
			{
				var loader:Loader = new Loader();
				loader.load(new URLRequest(url));
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event){
					image = (e.target.content as Bitmap);
					this.addChild(image);
					this.graphics.beginFill(0xffffff);
					this.graphics.drawRect(0, 0, b.width, b.height);
					this.graphics.endFill();
				});
			}
			return this;
		}
		

	}
	
}
