package {
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	public class as3_load_example extends MovieClip {
		
		private var _loaderCU3ER : Loader;
		
		public function as3_load_example() {
			trace("[as3_load_example] as3_load_example start");
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			// start loading CU3ER
			_loadCU3ER("CU3ER-config.xml", 640, 535);
			
			stop();

		}
		
		private function _loadCU3ER(xmlLocation:String, width:Number,height:Number) {
			_loaderCU3ER = new Loader();
			_loaderCU3ER.contentLoaderInfo.addEventListener(Event.COMPLETE, _placeCU3ER);
			
			// define CU3ER URL, together with variables for XML location and forced CU3ER stage width and height
			var url:String = "CU3ER.swf?xml_location="+xmlLocation+"&stage_width="+width+"&stage_height="+height;
			var urlReq:URLRequest = new URLRequest(url);
			_loaderCU3ER.load(urlReq);
		}
		
		function _placeCU3ER(event:Event):void{
			trace("[as3_load_example] _placeCU3ER");
			
			// add CU3ER to stage
			this.addChild(_loaderCU3ER.content as MovieClip);
			
			// you can position CU3ER after loading SWF
			_loaderCU3ER.content.x = 50;
			_loaderCU3ER.content.y=80;
				
			// assign functions to loaded CU3ER for handling events
			(_loaderCU3ER.content as MovieClip).onSlide = _onSlide;
			(_loaderCU3ER.content as MovieClip).onTransition = _onTransition;
			(_loaderCU3ER.content as MovieClip).onLoadComplete = _onLoadComplete;
		}
		
		private function _onLoadComplete(slidesOrder:String):void {
			trace("[as3_load_example] _onCU3ERLoadComplete with slides order :"+slidesOrder);
			
			// add events for buttons controlling CU3ER 
			
			btnNext.addEventListener(MouseEvent.CLICK, _handleClick);
			btnPrev.addEventListener(MouseEvent.CLICK, _handleClick);
			btnPlay.addEventListener(MouseEvent.CLICK, _handleClick);
			btnPause.addEventListener(MouseEvent.CLICK, _handleClick);
			btnSkip.addEventListener(MouseEvent.CLICK, _handleClick);
			
			btnNext.buttonMode = btnPrev.buttonMode = btnPlay.buttonMode = btnPause.buttonMode = btnSkip.buttonMode = true;
			
			txtInfo.appendText("\non load complete");
			txtInfo.appendText("\nslides order : "+ slidesOrder.split("|"));
		}
		
		private function _handleClick(event:MouseEvent):void{
			switch(event.target.name){
				case"btnNext":
					trace("next");
					(_loaderCU3ER.content as MovieClip).next();
				break;
				 
				case"btnPrev":
					trace("prev");
					(_loaderCU3ER.content as MovieClip).prev();
				break;
			
				case"btnPlay":
					trace("play");
					(_loaderCU3ER.content as MovieClip).playCU3ER();
				break;
			
				case"btnPause":
					trace("pause");
					(_loaderCU3ER.content as MovieClip).pauseCU3ER();
				break;
			
				case"btnSkip":
					trace("skip");
					(_loaderCU3ER.content as MovieClip).skipTo(3);
				break;
			}
		}

		

		function _onSlide(no:int):void {
			trace("[as3_load_example] _onSlide " + no);
			txtInfo.appendText("\non slide"+no);
		}
		
		function _onTransition(no:int):void {
			trace("[as3_load_example] _onTransition " + no);
			txtInfo.appendText("\non transition"+no);
		}
		
		
		
	}
	
}