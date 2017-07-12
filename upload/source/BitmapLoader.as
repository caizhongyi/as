package {
        import flash.display.Bitmap;
        import flash.display.BitmapData;
        import flash.display.Loader;
        import flash.display.Sprite;
        import flash.events.Event;
        import flash.net.URLRequest;
        import flash.sampler.Sample;

		// 图片合并加载
        public class BitmapLoader extends Sprite
        {
			public function unite(url1:String ,url2:String):Bitmap{
				var _this = this;
				var _loader1:Loader = new Loader();
				var _loader2:Loader = new Loader();
				_loader1.load(new URLRequest(url1));
				_loader1.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event){
					var _img1 = Bitmap(_loader1.content);
					_loader2.load(new URLRequest(url2));
					_loader2.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event){
						var _img2=Bitmap(_loader2.content);
						var bitmap:BitmapData=_img2.bitmapData;
                        bitmap.draw(_img1);
                        var displayimg:Bitmap=new Bitmap(bitmap);
					});
				});
			}
        }
}
