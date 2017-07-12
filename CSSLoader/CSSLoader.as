package  {
	import flash.net.URLLoader;
	import flash.text.StyleSheet;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	public class CSSLoader {

		public function CSSLoader() {
			
		}
		
		public function load(css:String, textField:TextField){
			// constructor code
			//var loader :URLLoader = new URLLoader();
			//var stylesheet:StyleSheet = new StyleSheet();
			var stylesheet = new textField.StyleSheet();
			//loader.load(new URLRequest(css));
			stylesheet.load(css);
			stylesheet.onLoad = function(bSuccess:Boolean):Void {
 				if (bSucess) {
					oStyle = this.getStyle("textbox");
 					for(var i in oStyle){
 					 	ccbTest.setStyle(i, oStyle[i]);
					}
  				} else {
    				trace("Error loading CSS file.");
  				}
			};
			
			//loader.addEventListener(Event.COMPLETE,  function()
			//{
	  	 		//stylesheet.parseCSS(loader.data);
	   	 		//object.styleSheet = stylesheet; 
			//});
	  
			
		}
	}
	
}
