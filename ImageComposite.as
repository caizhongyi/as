package  {     
        import flash.display.Bitmap;
        import flash.display.BitmapData;
        import flash.display.BitmapDataChannel;
        import flash.display.Loader;
        import flash.display.Sprite;
        import flash.events.*;
        import flash.events.IOErrorEvent;
        import flash.filters.DisplacementMapFilter;
        import flash.filters.DisplacementMapFilterMode;      
        import flash.geom.Matrix;
        import flash.geom.Point;
        import flash.net.URLRequest;
        //上面这些都是一些类或是包,也可以按照下面的方式写       
        [SWF(width="800", height="600", backgroundColor="#ffffff", frameRate="31")]
        //第一个参数设定输出swf尺寸为800x600 象素. 第二个参数设定背景色为白色，第三个参数设定播放帧速为31帧每秒。可以不需要
        public class ImageComposite extends Sprite{
                private var loader:Loader;
                private var _img1:Bitmap;
                private var _img2:Bitmap;
                public function ImageComposite()
                {
                     loader = new Loader();
                     //_loader2=new Loader();
                }
				
				public function composite(url:Array):Bitmap{
					//var bitmap = 
					//这里是小图片路径，图片合成时稍小的图片，注意使用双斜扛
                     loader.load(new URLRequest("E:\\pp.png"));
                     loader.addEventListene(IOErrorEvent.IO_ERROR,errorHandler);
                	 loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaderComplete);
					 return 
				}

                private function loaderComplete(event:Event):void
                {
                       _img1 = Bitmap(e.target as Bitmap);
                       addChild(_img1);
                        //这里是大图片的路径，图片合成时稍大的图片
                       _loader2.load(new URLRequest("E:\\football.png"));
                        //添加侦听事件，检测是否有输入错误，还有图片是否加载完成，有的话转向错误处理
                       _loader2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
                       _loader2.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete2); 
                }

                private function errorHandler(event:IOErrorEvent):void{
                  trace(event.text);//输出错误信息                
                }
                private function onComplete2(event:Event):void
                {
                      _img2=Bitmap(_loader2.content);
                      //实例化一个矩阵，主要是控制图片位置，这里最后两个参数：80，80，就是控制合成图片时的位置，需要使用者自己确定
                      var matrix:Matrix = new Matrix(1.0,0.0,0.0,1.0,80,80);                       
                      //一下参数都是为使用滤镜准备，基本上可以不用修改，已经做过大量测试，如果效果不是很好，可以微调scaleX，scaleY
                      var bitmap:BitmapData    = _img2.bitmapData;                  
                      var mapPoint:Point       = new Point(0, 0);
                      var channels:uint        = BitmapDataChannel.BLUE;
                      var componentX:uint      = channels;
                      var componentY:uint      = channels;
                      var scaleX:Number        = 10;
                      var scaleY:Number        = 10;
                      var mode:String          = DisplacementMapFilterMode.CLAMP;
                      var color:uint           = 0;
                      var alpha:Number         = 0;
                      //实例化滤镜
					  var filter:DisplacementMapFilter= new DisplacementMapFilter(bitmap,mapPoint,componentX,componentY,scaleX,scaleY,mode,color,alpha);            
                      var dstbitmap:Bitmap= new Bitmap(new BitmapData(_img2.width,_img2.height,true,0x00000000));
                      //将目标图片添加到一张与源图片大小一样的透明画布上,以便使用滤镜
                      dstbitmap.bitmapData.draw(_img1,matrix);
                      dstbitmap.filters=[filter];//使用滤镜
                      bitmap.draw(dstbitmap);
                      var displayimg:Bitmap=new Bitmap(bitmap);
                      //使用addChild显示合成后的效果图片
                      addChild(displayimg);
                }
        }
}
